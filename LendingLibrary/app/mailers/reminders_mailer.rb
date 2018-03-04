class RemindersMailer < ApplicationMailer
    #https://launchschool.com/blog/handling-emails-in-rails
    
    default from: "reminders@theeducationpartnership.org"
    
    def pick_up_reminder(user, reservation)
        @teacher = user
        @reservation = reservation
        mail(to: @teacher.email, subject: 'Pickup Reminder for STEAM Rental')
    end
    
    def drop_off_reminder(user, reservation)
        @teacher = user
        @reservation = reservation
        mail(to: @teacher.email, subject: 'Pickup Reminder for STEAM Rental')
    end
end
