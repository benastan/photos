module Photos
  class Cli
    class LocalFileSystemBrowser < Base
      def initialize(file_system)
        @file_system = file_system
      end
      
      def browse
        directory = select_directory
        photo = select_photo(directory)
        photo_menu(photo)
      end
      
      def select_directory
        menu_options = @file_system.directory(:Originals)
        menu = View::Select.new('Which Directory?', menu_options) { |o| o[1] }
        menu.selection[0]
      end
      
      def select_photo(directory)
        menu_options = @file_system.fetch_directory_photo_list(directory)
        menu = View::Select.new('Which File?', menu_options) { |o| o[1] }
        Photo.new(URI("file://#{menu.selection[0]}"))
      end
      
      def photo_menu(photo)
        menu_options = [
          [ :open, 'Open Image' ],
          [ :resize, 'Resize Image' ],
        ]
        
        menu = View::Select.new('What next?', menu_options) { |o| o[1] }
        case menu.selection[0]
        when :open then photo.open
        when :resize
          size = View::Input.new('Size')
          resized_photo = photo.sample(size.value)
          resized_photo.open
        end
      end
    end
  end
end
