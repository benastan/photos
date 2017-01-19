module Photos
  class Cli
    class MainMenu < Base
      def perform
        main_menu_options = [
          [ :remote, 'Browse Remote Filesystem'],
          [ :local, 'Browse Local Filesystem' ],
          [ :utils, 'Utilities' ]
        ]
        
        print "Main Menu\n"
        main_menu = View::Select.new('What do you want to do?', main_menu_options) { |o| o.last }
        
        case main_menu.selection[0]
        when :remote
          # uri = URI::HTTP.build([ 's3', ENV['AWS_BUCKET'] ])
          # RemoteFileSystemBrowser.new(uri).browse
          # TODO
        when :local
          LocalFileSystem.new.browse
        when :utils
          Utilities.new
        end
      end
    end
  end
end