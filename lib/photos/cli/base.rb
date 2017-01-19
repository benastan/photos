module Photos
  class Cli
    class Base
  
      def open(uri)
        path = aws(:s3, :presign, uri)
        %x(open #{path})
      end
  
      def download(path, raw: false)
        path = raw ? path.gsub('JPG', 'ARW') : path
    
        pathname = Pathname(path)
        basename = pathname.basename
        directory = Time.new.strftime('%Y-%m-%d')
    
        destination = Pathname("#{ENV['DEFAULT_DOWNLOAD']}/#{directory}/#{basename}")
        FileUtils.mkdir_p(destination.dirname.to_s)
    
        url = aws(:s3, :presign, path).chomp
        print "\nDownloading to #{destination.to_s}...\n"
    
        res = Faraday.get(url)
        destination.write(res.body)
        print "Done!\n\n"
      end
      
      def aws(service, command, *args)
        command = args.dup
        command.unshift(command, service)
        system!(:aws, service, command *args)
      end
      
      def system!(*args)
        stdin, stdout = Open3.popen2(*args)
  
        output = ''
  
        while line = stdout.gets
          print line
          output << line
        end
  
        output
      end
    end
  end
end
