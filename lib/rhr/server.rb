require 'rhr/view'
require 'rhr/core_ext/object'

module RHR
  class Server
    def initialize
      @files = Dir["**/*"] - %w[Gemfile Gemfile.lock Rakefile helpers.rb]
      @files -= @files.grep(/(^|\/)_/)
    end

    def call(env)
      path = env['PATH_INFO']
      if template = find_template(path)
        if renderer = Tilt[template]
          request = Rack::Request.new(env)
          params = request.GET.merge(request.POST)

          helpers_path = find_helpers
          require(helpers_path) if helpers_path
          view = View.new
          view.send(:extend, Helpers) if defined?(Helpers)

          body = renderer.new(template).render(view, :request => request, :params => params)

          if layout = find_layout
            body = renderer.new(layout).render(view, :request => request, :params => params) { body }
          end

          [200, {}, [body]]
        else
          Rack::File.new('.').call(env.merge('PATH_INFO' => template))
        end
      else
        [404, {}, ['404 File not found']]
      end
    end

  private

    def find_helpers
      Dir['*'].grep(/^helpers.rb$/).first
    end
    memoize :find_helpers

    def find_layout
      Dir['*'].grep(/^_layout(\.|$)/).first
    end
    memoize :find_layout

    def find_template(path)
      file = path.dup
      file.sub!('/','')
      file.sub!(/\/$/,'')
      is_root = (file == '')

      return if not is_root and not @files.index(file)

      if is_root or File.directory?(file)
        # folder -> find an index file
        file << '/' unless is_root
        @files.grep(/^#{Regexp.escape file}index\.[^\/]+$/).first
      else
        # just another normal template
        file
      end
    end
    memoize :find_template
  end
end
