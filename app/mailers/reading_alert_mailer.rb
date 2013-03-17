class ReadingAlertMailer < ActionMailer::Base
  default :from=> "sanjay.manchiganti@gmail.com"


  def send_alert(customer_names_for_alert)
  	@customer_names_for_alert = customer_names_for_alert
  	mail(:to=>'email2sanjay@yahoo.com',:subject=>'Reading Alert')

  end

end
