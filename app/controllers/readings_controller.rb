require 'csv'
require 'active_support/core_ext/hash'


class ReadingsController < ApplicationController
  # GET /readings
  # GET /readings.json
  def index

    #  CSV.foreach('daily_files/DailyData_Original.txt',:headers=>true,:col_sep=>'|') do | row|
    #    puts row.to_hash
    #    logger.debug("Hash is #{row.to_hash}")
    #     Reading.create!(row.to_hash)
    #  end
    # #logger.debug("Search text is #{params[:search_text]}")
    # #@readings = Reading.where("corrected_amt > ?",params[:search_text])
    
    logger.debug "boolean value is #{@readings.nil?}"
    @readings = Reading.all if @readings.nil?

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @readings }
    end
  end


  def search
     puts "Inside search #{params[:corrected_amt]}"
     #where_condition = params[:corrected_amt] unless params[:corrected_amt].nil?
     
     corrected_amt = params[:corrected_amt]
     start_date = params[:start_date]
     end_date = params[:end_date]
     customer_name = params[:customer_name]

     @readings = Reading.where("corrected_amt > ? and read_date between ? and ? and customer_name = ?",
            corrected_amt,start_date,end_date,customer_name)
     logger.debug("size is #{@readings.size}")
     puts "size is #{@readings.size}"
     render :action=>:index

  end  

  # GET /readings/1
  # GET /readings/1.json
  def show
    

    @reading = Reading.find

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reading }
    end
  end

  # GET /readings/new
  # GET /readings/new.json
  def new
    @reading = Reading.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reading }
    end
  end

  # GET /readings/1/edit
  def edit
    @reading = Reading.find(params[:id])
  end

  # POST /readings
  # POST /readings.json
  def create
    @reading = Reading.new(params[:reading])

    respond_to do |format|
      if @reading.save
        format.html { redirect_to @reading, notice: 'Reading was successfully created.' }
        format.json { render json: @reading, status: :created, location: @reading }
      else
        format.html { render action: "new" }
        format.json { render json: @reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /readings/1
  # PUT /readings/1.json
  def update
    @reading = Reading.find(params[:id])

    respond_to do |format|
      if @reading.update_attributes(params[:reading])
        format.html { redirect_to @reading, notice: 'Reading was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reading.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readings/1
  # DELETE /readings/1.json
  def destroy
    @reading = Reading.find(params[:id])
    @reading.destroy

    respond_to do |format|
      format.html { redirect_to readings_url }
      format.json { head :no_content }
    end
  end

def search
    @readings = Reading.where("corrected_amt > ?",params[:threshold_search])
    logger.debug "inside search "
  end

end
