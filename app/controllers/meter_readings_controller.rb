require 'smarter_csv'
require 'active_support/core_ext/hash'
require 'net/ftp'

class MeterReadingsController < ApplicationController
  # GET /meter_readings
  # GET /meter_readings.json

  def refreshDailyData
     customer_names_for_alerts = Array.new;


  logger.info("#{Dir.exist?('./tmp/daily_files')}")
  Dir.mkdir('./tmp/daily_files') unless Dir.exist?('./tmp/daily_files')
  Dir.chdir('./tmp/daily_files') do
    
  Net::FTP.open("ftp.fkaa.com") do |ftp|
       ftp.passive = true
       ftp.login("admin.mywateriq@fkaa.com","89jSAQ6E")
       logger.info("getting files")
       ftp.get("orc_meters.txt")
  end
end
  curr_date = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
  FileUtils.mv('./tmp/daily_files/orc_meters.txt',"./tmp/daily_files/orc_meters_#{curr_date}.txt")


     puts "File is downloaded successfully"
   #end

    # lines = []
    # IO.foreach( "daily_files/orc_meters_working_whole.txt" ) do |line|
    #   lines << line.split('\t').map { |v| v.strip }
    # end  

    # #puts "lines are:"
    # lines.each do |line|
    #   puts lines.join("!")
    # end

    # File.open("daily_files/orc_meters_working_parsed.txt","w") { |f| f.write(lines) } 
    #file_to_be_processed = 'daily_files/orc_meters_original1.txt';

  row_count = 0
  Dir.foreach("./tmp/daily_files/") {|file_to_be_processed| puts "File is #{file_to_be_processed}"}
  #Dir.foreach("daily_files") {|file_to_be_processed| logger.debug "File is #{file_to_be_processed}"}
  #Dir.glob("daily_files/*.txt") {|file_to_be_processed| logger.debug "File is #{file_to_be_processed}"
  Dir.glob("./tmp/daily_files/*.txt") { |file_to_be_processed|
    logger.debug "processing file #{file_to_be_processed}"
    arr = SmarterCSV.process(file_to_be_processed,{:col_sep=>"\t",:key_mapping => {:usage=>:usage_number}})
    prev_row = Hash.new
    arr.each { |row|
      row_count = row_count + 1
      curr_row = row

      if curr_row[:read_date]
      curr_row[:read_date] = DateTime.strptime(curr_row[:read_date],"%m/%d/%y").strftime("%Y-%m-%d") unless curr_row[:read_date].nil?
      curr_row[:read_date] = curr_row[:read_date] + ' ' + curr_row[:last_time]
      curr_row.delete(:last_time)

      if prev_row[:remote_id]
        if prev_row[:remote_id] == curr_row[:remote_id]
          logger.debug "Remote ids are equal"
          curr_row[:usage_number] = curr_row[:corrected_amt].to_f - prev_row[:corrected_amt].to_f
          logger.debug "Current row usage number is #{curr_row[:usage_number]}"
          if curr_row[:usage_number] > 6000
            curr_row[:large_amt] = "***"
          else
            curr_row[:large_amt] = ""
          end
          logger.debug "Creating MeterReading"
          MeterReading.create!(prev_row)
          MeterReading.create!(curr_row)
        else
          logger.debug "prev_row remote id is not equal to curr_row remote id. First row of iterationsetting the defaults for the curr row"
          curr_row[:usage_number] = ""  
          curr_row[:large_amt] = ""    
        end
      else
        logger.debug "First time setting the defaults for the curr_row"
        curr_row[:usage_number] = ""  
        curr_row[:large_amt] = ""  
      end

      prev_row = curr_row

         if(row[:large_amt]=='***')
           customer_names_for_alerts << row[:ocr_street_addr]
         end
      end
    }
    FileUtils.mv(file_to_be_processed,'processed')
  }
    puts "Remote Ids that have a problem #{customer_names_for_alerts}"
    puts "Number of rows processed #{row_count}"

    ReadingAlertMailer.send_alerts(customer_names_for_alerts).deliver if customer_names_for_alerts.size > 0

  end

  def old_refreshDailyData
    customer_names_for_alerts = '';
      #threshold = Threshold.find(:first)
      threshold_value = 200000;#threshold.threshold_value      

    CSV.foreach('daily_files/orc_meters.txt',:headers=>true,:col_sep=>'\t') do | row|
      puts row.to_hash
      logger.debug("Hash is #{row.to_hash}")
      hash_val = row.to_hash 
      logger.debug("date is #{hash_val["read_date"]}")
      hash_val["read_date"] = DateTime.strptime(hash_val["read_date"],"%m/%d/%y").strftime("%Y-%m-%d") unless hash_val["read_date"].nil?

      hash_val["read_date"] = hash_val["read_date"]+hash_val["last_time"]


      
      if(hash_val["corrected_amt"].to_f > threshold_value)
        if(customer_names_for_alerts=='')
         customer_names_for_alerts = hash_val["customer_name"]
        else
          customer_names_for_alerts = customer_names_for_alerts + "<br>" + hash_val["customer_name"]
        end
      end

      logger.debug("new hash is is #{hash_val}")
      MeterReading.create!(hash_val)
    end
    #ReadingAlertMailer.send_alert(customer_names_for_alerts).deliver
    logger.debug("Customer names above the threshold are "+customer_names_for_alerts);
  end


  def index
  
    start_date = ((DateTime.now)-10).strftime("%Y-%m-%d") 
    end_date = ((DateTime.now)-1).strftime("%Y-%m-%d")


    @readings = MeterReading.where("read_date >= ? and read_date <= ?",
       start_date,end_date).order("corrected_amt DESC").limit(200)

    @readings = Array.new if @readings.nil?


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meter_readings }
    end
  end

  # GET /meter_readings/1
  # GET /meter_readings/1.json
  def show
    @meter_reading = MeterReading.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @meter_reading }
    end
  end

  # GET /meter_readings/new
  # GET /meter_readings/new.json
  def new
    @meter_reading = MeterReading.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @meter_reading }
    end
  end

  # GET /meter_readings/1/edit
  def edit
    @meter_reading = MeterReading.find(params[:id])
  end

  # POST /meter_readings
  # POST /meter_readings.json
  def create
    @meter_reading = MeterReading.new(params[:meter_reading])

    respond_to do |format|
      if @meter_reading.save
        format.html { redirect_to @meter_reading, notice: 'Meter reading was successfully created.' }
        format.json { render json: @meter_reading, status: :created, location: @meter_reading }
      else
        format.html { render action: "new" }
        format.json { render json: @meter_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meter_readings/1
  # PUT /meter_readings/1.json
  def update
    @meter_reading = MeterReading.find(params[:id])

    respond_to do |format|
      if @meter_reading.update_attributes(params[:meter_reading])
        format.html { redirect_to @meter_reading, notice: 'Meter reading was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @meter_reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meter_readings/1
  # DELETE /meter_readings/1.json
  def destroy
    @meter_reading = MeterReading.find(params[:id])
    @meter_reading.destroy

    respond_to do |format|
      format.html { redirect_to meter_readings_url }
      format.json { head :no_content }
    end
  end

  def search
     puts "Inside search #{params[:corrected_amt].nil?}"
     #where_condition = params[:corrected_amt] unless params[:corrected_amt].nil?

     corrected_amt = params[:corrected_amt]
     corrected_amt = 0 if corrected_amt.to_s==''
     start_date = params[:start_date]
     #start_date = DateTime.now.strftime("%Y-%m-%d") if start_date.to_s == ''
     start_date = DateTime.now.strftime("%Y-%m-%d") if start_date.to_s == ''
     params[:start_date]=start_date
     end_date = params[:end_date] 
     end_date =DateTime.now.strftime("%Y-%m-%d") if end_date.to_s == ''
     params[:end_date]=end_date
     leak_status = Array.new


     if (params[:leak_status]=='All')
       leak_status = [0,1,2]
     else
       leak_status[0] =  params[:leak_status]
     end


     # customer_name = params[:customer_name]
     # if customer_name.to_s == ''
     #    customer_name = '%'
     # else
     #    customer_name = '%'+customer_name+'%'
     # end

     # @readings = MeterReading.where("corrected_amt > ? and read_date between ? and ? and customer_name like ?",
     #   corrected_amt,start_date,end_date,customer_name).order("corrected_amt DESC").limit(200)
     @readings = MeterReading.where("corrected_amt > ? and read_date >= ? and read_date <= ? 
       and usage_number is not null and leak_status in (?)",
       corrected_amt,start_date,end_date, leak_status.collect()).order("corrected_amt DESC").limit(200)

     logger.debug("size is #{@readings.size}")
     puts "size is #{@readings.size}"
     render :action=>:index
  end
end
