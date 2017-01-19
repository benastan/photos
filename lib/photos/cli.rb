module Photos
  class Cli
    autoload :Base, 'photos/cli/base'
    autoload :MainMenu, 'photos/cli/main_menu'
    autoload :Utilities, 'photos/cli/utilities'
    autoload :LocalFileSystemBrowser, 'photos/cli/local_file_system_browser'
    autoload :RemoteFileSystemBrowser, 'photos/cli/remote_file_system_browser'
    autoload :View, 'photos/cli/view'
    
    def self.perform
      MainMenu.new.perform
    end

    def self.main_menu
      photos_list = %x(aws s3 ls --recursive s3://#{ENV['AWS_BUCKET']} | grep JPG | awk '{print $4}').split("\n")
  
      loop do
    
        photos = View::Select.new('Which photo?', photos_list)
        path = "s3://#{ENV['AWS_BUCKET']}/#{photos.selection}"
    
        menu_options = [
          [:view, 'View in Browser'],
          [:download_jpg, 'Download JPG'],
          [:download_arw, 'Download ARW'],
          [:done, 'Done'],
        ]
    
    
        loop do
          menu = View::Select.new('What next?', menu_options) { |option| option[1] }
      
          case menu.selection[0]
          when :view
            open(path)
          when :download_jpg
            download(path)
          when :download_arw
            download(path, raw: true)
          else break
          end
        end
      end
    end
  end
end
