require 'net/ftp'

task :getdailyfiles do 

	Dir.chdir("daily_files") do
		
		Net::FTP.open("ftp.fkaa.com") do |ftp|
			ftp.passive = true
			ftp.login("admin.mywateriq@fkaa.com","89jSAQ6E")
			ftp.get("orc_meters.txt")
		end
		curr_date = Time.now.strftime("%Y_%m_%d")
		FileUtils.mv('orc_meters.txt',"orc_meters_#{curr_date}.txt")

	end


	
end