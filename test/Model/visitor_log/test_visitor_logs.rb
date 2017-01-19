require_relative '../../test_helper'
require 'minitest/autorun'
class TestVisitorsLog < Minitest::Test
  def setup
    @visitor_log = TurboCassandra::VisitorLog.new
    @visitor_log_backend = TurboCassandra::VisitorLogBackEnd.new

    @generator = Cassandra::Uuid::Generator.new
  end
  def test_new
    hash = {
        visitor_id: @generator.uuid,
        date: Time.now.to_time,
        id: @generator.now,
        ip: Cassandra::Types::Inet.new('192.168.1.1'),
        customer_id: 1,
        product: 123
    }
    @visitor_log.insert hash
  end

  def test_insert
    hash = {
        visitor_id: 'cef86c37-aedb-485b-a785-be04d1a99829',
        ip: '192.168.1.1',
        customer_id: 1,
        product: 123
    }
    @visitor_log_backend.new hash
  end

  def test_select

    results  = @visitor_log_backend.last5_customer(487)
    p results
  end
end