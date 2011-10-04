module RHR
  class Server
    def initialize
      @files = Dir["**/*"]
    end

    def call(env)
      path = env['PATH_INFO']
      if template = find_template(path)
        body = if renderer = Tilt[template]
          renderer.new(template).render
        else
          File.read(template)
        end
        [200, {}, [body]]
      else
        [404, {}, ['404 File not found']]
      end
    end

  private

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
  end
end
