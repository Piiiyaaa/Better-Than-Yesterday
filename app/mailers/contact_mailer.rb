class ContactMailer < ApplicationMailer
    def send_mail(contact)
      @contact = contact
      mail to: ENV["MAILER_ADDRESS"], subject: "【お問い合わせ】" + @contact.subject
    end
end
