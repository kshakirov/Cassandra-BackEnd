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
        visitor_id: 'cef86c37-aedb-485b-a785-be04d1a99821',
        ip: '192.168.1.1',
        customer_id: 1,
        product: rand(10000)
    }
    @visitor_log_backend.new_visit(hash)
    hash2 = {
        visitor_id: 'cef86c37-aedb-485b-a785-be04d1a99831',
        ip: '192.168.3.25',
        customer_id: 1,
        product: rand(10000)
    }
    @visitor_log_backend.new_customer_visit(hash2)

  end

  def test_select

    results  = @visitor_log_backend.last5_customer(1)
    p results
    results  = @visitor_log_backend.last5_visitor('cef86c37-aedb-485b-a785-be04d1a99821')
    p results
  end
end