class AccountMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  
  
   @@smtp_settings = {
      :address              => ENV["email_addr"],
      :port                 => ENV["email_port"],
      :authentication       => ENV["email_auth"],
      :user_name            => ENV['account_email_username'],
      :password             => ENV['account_password']
      :enable_starttls_auto => ENV['tls_auto']
    }

end