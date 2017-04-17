require '../test_helper'

class TestMessageLogModel < Minitest::Test
  def setup
    @generator = Cassandra::Uuid::Generator.new

  end
  def test_insert
    id = @generator.now

    data = {
        customer_email: "kirill.shakirov4@gmail.com",
        id:  id,
        status: 'Queued',
        date_start:  Time.now.to_time,
        date_end:  Time.now.to_time,
        message: "Test message Model save"
    }
    message_log= TurboCassandra::Model::MessageLog.new data
    result  = message_log.save
    assert_equal id.to_s,  result
  end

  def test_find
    params = {
        customer_email: "kirill.shakirov4@gmail.com"
    }
      result  = TurboCassandra::Model::MessageLog.find_by params
      assert result.size > 0
  end

  def test_find_id
    result  = TurboCassandra::Model::MessageLog.find  "kirill.shakirov4@gmail.com",
                                                       Cassandra::TimeUuid.new('516e9280-210a-11e7-8954-1fb1ffadb73a')
    assert result.to_hash
  end

  def test_update
    data = {
        message: "Updated",
        status: "Success",
        date_end: Time.now.to_time
    }
    result  = TurboCassandra::Model::MessageLog.find  "kirill.shakirov4@gmail.com",
                                                       Cassandra::TimeUuid.new('813f4f20-2111-11e7-afa0-7db8bc900754')
    result.message= "Updated 2"
    result.save

    assert result
  end

end