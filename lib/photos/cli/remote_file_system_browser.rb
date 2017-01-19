module Photos
  class Cli
    class RemoteFileSystemBrowser < Base
      def initialize(uri)
        @uri = uri
        fetch_filesystem
      end
      
      def browse
      end
    end
  end
end