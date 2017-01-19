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
    
    def original
      if original?
        self
      else
        original_path = dirname.join("../Originals/#{basename}").to_s
        original_uri = uri.dup
        original_uri.path = original_path
        Photo.new(original_path)
      end
    end
    
    def content
      @content ||= Pathname(uri.to_s).read
    end
    
    def local?
      @uri.scheme == 'file'
    end
    
    def original?
      local? && dirname.join('..').basename.to_s == 'Originals'
    end
    
    def sample(size)
      destination = Pathname(ENV['LOCAL_DIRECTORY']).join(size, dirname.basename, basename)
      resized_uri = @uri.dup
      resized_uri.path = destination.to_s
      
      unless destination.exist?
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
