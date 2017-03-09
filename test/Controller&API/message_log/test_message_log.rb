require '../test_helper'

class TestMessageLogController < Minitest::Test
  def setup
    @message_log_api = TurboCassandra::API::MessageLog.new
    @rabbit_queue = TurboCassandra::Controller::RabbitQueue.new("localhost")
    @message_log_controller = TurboCassandra::Controller::MessageLog.new(@rabbit_queue.connection)
    @generator = Cassandra::Uuid::Generator.new
  end

  def test_add_reset_msg
    request = {
        'email' => "kshakirov@zoral.com.ua"
    }
    result = @message_log_controller.add_password_reset_msg(request.to_json, "kshakirov@zoral.com.ua")
    refute_nil result

  end

  def test_add_new_customer
    request = {
        'email' => "kshakirov@zoral.com.ua"
    }
    result = @message_log_controller.add_new_customer_msg(request.to_json, "kshakirov@zoral.com.ua")
    refute_nil result
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

  def teardown
    p "Finishing tests"
    @rabbit_queue.connection.close
  end

end