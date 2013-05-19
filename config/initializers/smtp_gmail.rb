ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "sanjay.manchiganti@gmail.com",
  :password             => "1yajnas1",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
