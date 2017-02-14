require '../test_helper'

class TestMessageLogController < Minitest::Test
  def setup
    @message_log_api = TurboCassandra::API::MessageLog.new
    @message_log_controller = TurboCassandra::Controller::MessageLog.new
    @generator = Cassandra::Uuid::Generator.new()
  end

  def test_add
    request = {
        email: "kshakirov@zoral.com.ua"
    }
    result = @message_log_controller.add_password_reset_msg(request.to_json, "kshakirov@zoral.com.ua")
    assert_nil result
    p "end"
  end

  def test_insert
    message_data = {
        sender_email: "kshakirov@zoral.com.ua",
        recepient_email: "kirill.shakirov@gmail.com",
        message: "Testing API"
    }

    result = @message_log_api.add_message(message_data)
    assert result
  end

  def test_find
    result = @message_log_api.get_message_by_sender_email "kshakirov@zoral.com.ua"
    assert result.size > 0
  end



end