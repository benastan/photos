module Photos
  class Photo
    attr_reader :pathname
    
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
        original.sample(version, resize: true, options: ['-quality', '70'], cache: false)
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
    
    def sample(size, cache: true, generate: true, resize: true, options: nil)
      options ||= []
      options = options.dup
      destination = Pathname(ENV['LOCAL_DIRECTORY']).join(size, dirname.basename, basename)
      resized_uri = @uri.dup
      resized_uri.path = destination.to_s
      
      if (!destination.exist? && generate) || !cache
        FileUtils.mkdir_p(destination.dirname)
        
        operation = resize ? '-resize' : '-sample'
        options = options.unshift(operation, size)
        options = options.unshift('convert')
        options = options.push(@pathname.to_s, destination.to_s)
        
        @shell.system!(*options)
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
