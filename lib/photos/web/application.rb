module Photos
  module Web
    class Application < Sinatra::Base
      get '/' do
        @file_system = LocalFileSystem.new
        slim :index
      end
      
      get '/directories/:directory' do
        @file_system = LocalFileSystem.new

        @directory = @file_system.directory(:Originals).detect do |directory|
          directory[1].basename.to_s == params[:directory]
        end
        
        @photos = Dir.glob(@directory[0].join('*.JPG')).map do |path|
          uri = URI('file:///')
          uri.path = path
          Photo.new(uri)
        end
        
        slim :directory
      end
      
      get '/photos/*' do
        location = env['PATH_INFO'].gsub(/^\/photos\//, '')
        @file_system = LocalFileSystem.new
        photo = @file_system.find_photo(location)

        photo.create if !photo.exist?
        
        headers['Content-Type'] = 'image/jpg'
        photo.content
      end
    end
  end
end
