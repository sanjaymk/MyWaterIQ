require 'csv'
require 'active_support/core_ext/hash'

class MeterReadingsController < ApplicationController
  # GET /meter_readings
  # GET /meter_readings.json

  def refreshDailyData
    customer_names_for_alerts = '';
      #threshold = Threshold.find(:first)
      threshold_value = 20000;#threshold.threshold_value      

    CSV.foreach('daily_files/DailyData.txt',:headers=>true,:col_sep=>'|') do | row|
      puts row.to_hash
      logger.debug("Hash is #{row.to_hash}")
      hash_val = row.to_hash 
      logger.debug("date is #{hash_val["read_date"]}")
      hash_val["read_date"] = DateTime.strptime(hash_val["read_date"],"%m/%d/%y").strftime("%Y-%m-%d") unless hash_val["read_date"].nil?
      

      
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
    ReadingAlertMailer.send_alert(customer_names_for_alerts).deliver
    logger.debug("Customer names above the threshold are "+customer_names_for_alerts);
  end


  def index
  
      #@readings = MeterReading.find() if @readings.nil?
    @readings = Array.new if @readings.nil?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meter_readings }
    end
  end

  def readCSV

    CSV.foreach('daily_files/DailyData3.txt',:headers=>true,:col_sep=>'|') do | row|
      puts row.to_hash
      logger.debug("Hash is #{row.to_hash}")
      MeterReading.create!(row.to_hash)
      #TestForInt.create!(row.to_hash)
    end
    @readings = Reading.where("corrected_amt = ?","103333")


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
     start_date = "2013-03-09"#DateTime.now.strftime("%Y-%m-%d") if start_date.to_s == ''
     params[:start_date]=start_date
     end_date = params[:end_date] 
     end_date ="2013-03-09"# DateTime.now.strftime("%Y-%m-%d") if end_date.to_s == ''
     params[:end_date]=end_date
     customer_name = params[:customer_name]
     if customer_name.to_s == ''
        customer_name = '%'
     else
        customer_name = '%'+customer_name+'%'
     end

     @readings = MeterReading.where("corrected_amt > ? and read_date between ? and ? and customer_name like ?",
       corrected_amt,start_date,end_date,customer_name).order("corrected_amt DESC").limit(200)
     logger.debug("size is #{@readings.size}")
     puts "size is #{@readings.size}"
     render :action=>:index

end


end
