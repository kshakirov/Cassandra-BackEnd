class Mailer < ActionMailer::Base
  def notification mail_data
    @mail_data = mail_data
    mail(
        :to      => "kirill.shakirov4@gmail.com",
        :from    => "kyrylo.shakirov@zorallabs.com",
        :subject => "Comment from Contact Us") do |format|
      format.text
      format.html
    end
  end
  def place_order customer, order
    @customer = customer
    @order = order
    mail(
        :to      => @customer['email'],
        :from    => "kyrylo.shakirov@zorallabs.com",
        :subject => "Order Placement") do |format|
      format.html
    end
  end
end