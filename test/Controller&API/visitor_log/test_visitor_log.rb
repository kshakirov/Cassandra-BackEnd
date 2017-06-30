require_relative '../test_helper'

class TestVisitorLog < Minitest::Test
  def setup
    @queue = "behavioral_queue"
    rabbit_conn = MarchHare.connect(:hostname => 'localhost')
    channel = rabbit_conn.create_channel
    @channel = channel.queue(@queue)
  end

  def prep_queue_payload visitor_log
    {
        type: 'visitor_logs',
        data: {
            visitor_id: visitor_log['visitor_id'],
            date: (visitor_log['date'].to_f * 1000).to_i,
            id:  visitor_log['id'].to_s,
            ip: visitor_log['ip'].to_s
        }
    }
  end


  def test_all
    results  = TurboCassandra::Model::VisitorLog.all
    payloads = results.map{|r| prep_queue_payload(r).to_json}
    payloads.each do |payload|
      @channel.publish(payload, :routing_key => @queue)
    end
  end
end