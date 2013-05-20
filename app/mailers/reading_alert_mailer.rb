class ReadingAlertMailer < ActionMailer::Base
  default :from=> "sanjay.manchiganti@gmail.com"


  def send_alerts(customer_names_for_alert)
  	
  	@customer_names_for_alert = customer_names_for_alert
  	mail(:to=>'sanjay.manchiganti@gmail.com,hartman.grant@gmail.com,email2sanjay@yahoo.com',:subject=>'Reading Alert')

  end


  def send_alert
  	
  	mail(:to=>'sanjay.manchiganti@gmail.com',:subject=>'Reading Alert')

  end

end
