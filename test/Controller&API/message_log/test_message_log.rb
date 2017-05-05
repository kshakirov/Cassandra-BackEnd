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
    result = @message_log_controller.queue_password_reset_task(request.to_json)
    refute_nil result

  end

  def test_add_new_customer
    request = {
        'email' => "kshakirov@zoral.com.ua"
    }
    result = @message_log_controller.queue_new_customer_task(request.to_json)
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
    @rabbit_queue.connection.close
  end

  def test_order_task_msg
    request = {
        'email' => "kshakirov@zoral.com.ua",
        'order_id' => 100000001
    }
    result = @message_log_controller.queue_order_task(request.to_json)
    refute_nil result

  end

  def test_task_complete
    data = {
        'id' => 'c3cacc80-211f-11e7-884b-77058f46a03a',
        'message' => 'Customer [kshakirov@zoral.com.ua] Password [iRjHg4oTWfWCIQ] Reset and Sent',
        'email' => 'kshakirov@zoral.com.ua',
        'status' => 'Success'
    }
    result = @message_log_controller.log_task_complete(data.to_json)
    refute_nil result

  end

  def test_queue_notify
    request = {
        'email' => "kshakirov@zoral.com.ua",
        password: 'test',
        login: 'kshakirov'
    }
    result = @message_log_controller.queue_user_notification request.to_json
    refute_nil result

  end

end