require "photos/version"

module Photos
  autoload :Cli, 'photos/cli'
  autoload :Database, 'photos/database'
  autoload :Photo, 'photos/photo'
  autoload :Web, 'photos/web'
  autoload :LocalFileSystem, 'photos/local_file_system'
end
