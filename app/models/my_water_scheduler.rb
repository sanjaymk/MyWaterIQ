class MyWaterScheduler

  def startschedule
  	scheduler = Rufus::Scheduler.start_new
  	
  	scheduler.cron("7 23 * * *") do
  		intakeJob = MeterIntakeJob.new
  		intakeJob.getdailyreadingsfile
  	end

  end


end
