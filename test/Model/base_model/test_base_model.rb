require_relative '../test_helper'
module TurboCassandra
  class MessageLog < BaseModel
    self.primary_index 'message_id'
  end
end



class TestBaseModel < Minitest::Test
  def setup

  end

  def test_all
    res = TurboCassandra::MessageLog.all
    p res
  end

  def test_other
    Message.find_by({a: "fdf", b: "ccc"})
    Message.find_by({a: "fdf"})
    Message.find "test"
    message = TurboCassandra::MessageLog.new ({message_id: 1, email: "kshakirov@zoral.com.ua", date: Time.now})
    message.save
  end
end