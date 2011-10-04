module RHR
  class Server
    def initialize
      @files = Dir["**/*"]
    end

    def call(env)
      path = env['PATH_INFO']
      body = if template = find_template(path)
        File.read(template)
      else
        'OOOPS'
      end
      return [200, {}, [body]]
    end

  private

    def find_template(path)
      if path == '/'
        @files.detect{|f| f =~ /^index\.[a-z]+$/i }
      else
        path.sub('/','')
      end
    end
  end
end
