module Photos
  class Cli
    class Utilities
      def initialize
        menu_options = [
          [ :generate_thumbnails, 'Generate Thumbnails' ]
        ]
        
        menu = View::Select.new('Which utility?', menu_options) { |o| o[1] }
        
        case menu.selection[0]
        when :generate_thumbnails
          size = View::Input.new('Thumbnail size').value
          options = View::Input.new('Additional Options').value.split(' ')
          cache = View::Input.new('Skip if exists?', type: :boolean).value
          resize = View::Input.new('Resize instead of sample?', type: :boolean).value
          
          file_system = LocalFileSystem.new
          file_system.each(:Originals) do |photo|
            print "Resizing #{photo.dirname}/#{photo.basename} to #{size}...\n"
            photo.sample(size, options: options, cache: cache, resize: resize)
            print "Done!\n"
          end
        end
      end
    end
  end
end