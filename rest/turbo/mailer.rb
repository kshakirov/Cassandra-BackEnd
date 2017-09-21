# ActionMailer::Base.raise_delivery_errors = true
# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#     :address   => "localhost",
#     :port      => 25,
#     :authentication => nil,
#     :enable_starttls_auto => false
#
# }
# ActionMailer::Base.view_paths= "/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/views"

class Mailer < ActionMailer::Base
  def notification payload
    @payload = payload
    mail(
        :to      => "support@turbointernational.com",
        :from    => "admin@turbointernational.com",
        :subject => "Comment from Contact Us") do |format|
      format.text
      format.html
    end
  end

end
