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

 		first_line = ""
 		File.open("#{new_dir}/DailyData.txt","r"){|f|
 		f.gets;first_line=f.read	
 		first_line.gsub!("Corrected Amt","corrected_amt")
 		first_line.gsub!("LocationID","location_id")
 		first_line.gsub!("ServiceAddress","service_address")
 		}

		File.open("/home/sanjay/projects/rails/downloads/daily_files/#{new_dir}/DailyData.txt","w+"){|f|
			f.write(first_line)
 		} 		


 	end

end


end