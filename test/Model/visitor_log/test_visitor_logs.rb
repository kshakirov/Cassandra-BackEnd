require_relative '../../test_helper'
require 'minitest/autorun'
class TestVisitorsLog < Minitest::Test
  def setup
    @generator = Cassandra::Uuid::Generator.new
    @visitor_log_controller = TurboCassandra::Controller::VisitorLog.new
  end
  def test_new
    hash = {
        visitor_id: 576879073,
        date: Time.now.to_time,
        id: @generator.now,
        ip: Cassandra::Types::Inet.new('192.168.1.1'),
        customer_id: 1,
        product: 123
    }
    log  = TurboCassandra::Model::VisitorLog.new hash
    log.save
  end

  def test_insert
    hash = {
        visitor_id: 'cef86c37-aedb-485b-a785-be04d1a99821',
        ip: '192.168.1.1',
        customer_id: 1,
        product: rand(10000)
    }
    @visitor_log_controller.new_visit(hash)
    params = {}
    customer_data = {
        visitor_id: 'cef86c37-aedb-485b-a785-be04d1a99831',
        ip: '192.168.3.25',
        customer_id: 1,
        product: rand(10000)
    }
    @visitor_log_controller.new_customer_visit(customer_data, params)

  end

  def test_select
    results  = TurboCassandra::Model::VisitorLog.find_by  visitor_id: 576879073
    p results
  end
end