require '../test_helper'

class TestMessageLogModel < Minitest::Test
  def setup
    @message_log_model = TurboCassandra::Model::MessageLog.new
    @generator = Cassandra::Uuid::Generator.new
  end
  def test_insert
    data = {
        sender_email: "kshakirov@zoral.com.ua",
        recepient_email: "kirill.shakirov@gmail.com",
        date:  Time.now.to_time,
        id: @generator.uuid,
        message: "Test message Forgotten password"

    }

    result  = @message_log_model.insert(data)
    assert result
  end

  def test_find
      result  = @message_log_model.find_by_sender_email  "kshakirov@zoral.com.ua"
      assert result.size > 0
  end

end