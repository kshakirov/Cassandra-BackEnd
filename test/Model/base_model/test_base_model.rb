require_relative '../test_helper'
module TurboCassandra
  class MessageLog < BaseModel
    self.primary_index ['customer_email', 'id']
  end
end



class TestBaseModel < Minitest::Test
  def setup
    @generator = Cassandra::Uuid::Generator.new
  end

  def test_all
    res = TurboCassandra::MessageLog.all
    p res
  end


  def test_insert
    id = @generator.now
    data = {
        customer_email: "kirill.shakirov4@gmail.com",
        id:  id,
        status: 'Queued',
        date_start:  Time.now.to_time,
        date_end:  Time.now.to_time,
        message: "Test Base Model"
    }

    message_log = TurboCassandra::MessageLog.new (data)
    p message_log.save
  end

  def test_find_and
    res = TurboCassandra::MessageLog.find "kirill.shakirov4@gmail.com",
                                          Cassandra::TimeUuid.new('516e9280-210a-11e7-8954-1fb1ffadb73a')
    assert_equal "TurboCassandra::MessageLog", res.class.name
    res.message = "Test Again"
    res.date_start = Time.now
    res.date_end = Time.now
    res.status = 'Success'
    p res.to_hash
    out =res.save
    p out
  end

  def test_other
    Message.find_by({a: "fdf", b: "ccc"})
    Message.find_by({a: "fdf"})
    Message.find "test"

  end
end