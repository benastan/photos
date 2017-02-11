module Photos
  class LocalFileSystem
    attr_reader :pathname
    
    def initialize
      @directories = {}
      @uri = URI("file://#{ENV['LOCAL_DIRECTORY']}")
      @pathname = Pathname(@uri.path)
      fetch_directory(:Originals)
    end

    def find_photo(path)
      photo_pathname = self.pathname.join(path.gsub(/^\//, ''))
      photo_uri = @uri.dup
      photo_uri.path = photo_pathname.to_s
      Photo.new(photo_uri)
    end
    
    def directory(dirname)
      @directories[dirname]
    end
    
    def browse
      Cli::LocalFileSystemBrowser.new(self).browse
    end
    
    def fetch_directory(name)
      directory_path = @pathname.join(name.to_s, '*').to_s
      @directories[name] = Dir.glob(directory_path).
        select { |filename| File.directory?(filename) }.
        map { |filename|
        pathname = Pathname(filename)
        [ pathname, pathname.basename ]
      }
    end
    
    def each(dirname)
      directory(dirname).reverse.each do |group|
        Dir.glob(group[0].join('*.JPG')).reverse.each do |path|
          uri = URI("file://#{path}")
          photo = Photo.new(uri)
          yield(photo)
        end
      end
    end
    
    def fetch_directory_photo_list(directory)
      Dir.glob(directory.join('*.JPG').to_s).map do |path|
        pathname = Pathname(path)
        [ pathname, pathname.basename ]
      end
    end
  end
end