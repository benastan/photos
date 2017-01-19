module Photos
  class Photo
    def initialize(uri)
      @uri = uri
      @pathname = Pathname(uri.path)
      @shell = Cli::Base.new
    end
    
    def basename
      @pathname.basename
    end
    
    def dirname
      @pathname.dirname
    end
    
    def path
      @pathname.to_s
    end
    
    def version
      dirname.dirname.basename.to_s
    end
    
    def original
      if original?
        self
      else
        original_path = dirname.dirname.dirname.join('Originals', dirname.basename, basename).to_s
        original_uri = @uri.dup
        original_uri.path = original_path
        Photo.new(original_uri)
      end
    end
    
    def content
      @content ||= @pathname.read
    end
    
    def create
      if original? || !original.exist?
        raise ArgumentError.new('Original does not exists')
      else
        original.sample(version)
      end
    end
    
    def exist?
      @pathname.exist?
    end
    
    def local?
      @uri.scheme == 'file'
    end
    
    def original?
      local? && dirname.join('..').basename.to_s == 'Originals'
    end
    
    def sample(size, generate: true)
      destination = Pathname(ENV['LOCAL_DIRECTORY']).join(size, dirname.basename, basename)
      resized_uri = @uri.dup
      resized_uri.path = destination.to_s
      
      if !destination.exist? && generate
        FileUtils.mkdir_p(destination.dirname)
        
        @shell.system!(
          'convert', '-sample', size, @pathname.to_s, destination.to_s
        )
      end
      
      Photo.new(resized_uri)
    end
    
    def relative_path(relative_to = '')
      [ relative_to, dirname.dirname.basename, dirname.basename, basename ].join('/')
    end
    
    def open
      if local?
        @shell.system!('open', @pathname.to_s)
      end
    end
  end
end
