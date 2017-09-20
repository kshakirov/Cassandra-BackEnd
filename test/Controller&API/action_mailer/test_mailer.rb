require_relative'../test_helper'
require_relative '../../../rest/turbo/mailer'

class TestMailere < Minitest::Test
  def setup

  end

  def test_mail
    payload = {"email" => "kirill.shakirov4@gmail.com", "name"=> "sdsd", "comment"=> "dsd"}
    email = Mailer.notification payload
    email.deliver
  end

end