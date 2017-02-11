module Photos
  module Web
    class Application < Sinatra::Base
      attr_reader :file_system, :directories
      
      helpers ViewHelper
      
      before do
        @file_system = LocalFileSystem.new
        @directories = @file_system.directory(:Originals)
      end
      
      get '/' do
        slim :index
      end
      
      get '/directories/:directory' do
        @directory = directories.detect do |directory|
          directory[1].basename.to_s == params[:directory]
        end
        
        @directory_index = directories.index(@directory)

        @photos = Dir.glob(@directory[0].join('*.JPG')).map do |path|
          uri = URI('file:///')
          uri.path = path
          Photo.new(uri)
        end
        
        @sources = @photos.map do |photo|
          "/photos?path=#{photo.sample('1080x768').relative_path}"
        end
        
        slim :directory
      end
      
      post '/photos/move' do
        path = params[:path]
        directory = params[:destination]
        
        pathname = file_system.pathname.join(directory)
        FileUtils.mkdir_p(pathname.to_s)
        photo = file_system.find_photo(path)
        destination = pathname.join(photo.pathname.basename)
        destination.write(photo.content)
        redirect to(env['HTTP_REFERER'])
      end
      
      get '/photos' do
        location = params[:path].gsub(/^\/photos\//, '')
        photo = file_system.find_photo(location)

        photo.create if !photo.exist?
        
        headers['Cache-Control'] = 'public,max-age=86400'
        headers['Content-Type'] = 'image/jpg'
        photo.content
      end
    end
  end
end
