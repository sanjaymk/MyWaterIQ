require 'net/ftp'

task :getdailyfiles do 

	 Dir.mkdir("app/tmp/daily_files") unless Dir.exist?("./tmp/daily_files")
	Dir.chdir("app/tmp/daily_files") do
		
		Net::FTP.open("ftp.fkaa.com") do |ftp|
			ftp.passive = true
			ftp.login("admin.mywateriq@fkaa.com","89jSAQ6E")
			ftp.get("orc_meters.txt")
		end
		curr_date = Time.now.strftime("%Y_%m_%d")
		FileUtils.mv('orc_meters.txt',"orc_meters_#{curr_date}.txt")


		puts "File is downloaded successfully"
	end


	Dir.foreach("./tmp/daily_files") {|file_to_be_processed| puts "File is #{file_to_be_processed}"}
	


end
