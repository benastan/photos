module Photos
  module Web
    module ViewHelper
      def directory_link_data(index)
        return {} if @directory.nil?
        
        if next_directory?(index)
          key_code = 40
        elsif previous_directory?(index)
          key_code = 38
        end
    
        { bind_key: "#{key_code}:link" } if key_code
      end
      
      def next_directory?(index)
        p index, @directory_index
        next_index = (@directory_index + 1) % @directories.size
        next_index == index
      end
    
      def previous_directory?(index)
        previous_index = (@directory_index - 1) % @directories.size
        previous_index == index
      end
    end
  end
end
