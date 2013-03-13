require 'net/ftp'

class MeterIntakeJob

def getdailyreadingsfile
 	Net::FTP.open('ftp.fkaa.com') do |ftp|
 		ftp.login("admin.mywateriq@fkaa.com","89jSAQ6E")
 		#get all these values from a yaml file
 		new_dir = '/home/sanjay/projects/rails/downloads/daily_files/'+DateTime.now.strftime("%Y%m%d%H%M%S")
 		Dir.mkdir(new_dir)
 		ftp.gettextfile("DailyData.txt",new_dir+'/DailyData.txt')
 		ftp.close
 	end

end


end