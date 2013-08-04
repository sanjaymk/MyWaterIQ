require 'net/ftp'

task :getdailyfileslist do 

	 

	Dir.foreach("/tmp/daily_files") {|file_to_be_processed| puts "File is #{file_to_be_processed}"}
	


end
