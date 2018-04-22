class RemindersMailer < ApplicationMailer
    default from: ENV['reminder_email_username']
    
    @@smtp_settings = {
      :address              => ENV["email_addr"],
      :port                 => ENV["email_port"],
      :authentication       => ENV["email_auth"],
      :user_name            => ENV['reminder_email_username'],
      :password             => ENV['reminder_password'],
      :enable_starttls_auto => ENV['tls_auto']
    }
    
    
    
    def pick_up_reminder(user, reservation)
        @teacher = user
        @reservation = reservation
        mail(to: @teacher.email, subject: 'Pickup Reminder for STEAM Reservation')
        mail.delivery_method.settings.merge! @smtp_settings
    end
    
    def drop_off_reminder(user, reservation)
        @teacher = user
        @reservation = reservation
        mail(to: @teacher.email, subject: 'Pickup Reminder for STEAM Reservation')
        mail.delivery_method.settings.merge! @@smtp_settings
        mail
    end
end
