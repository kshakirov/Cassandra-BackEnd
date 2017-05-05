require_relative "../test_helper"
class TestTemplate < Minitest::Test
  def setup
    @template_controller = TurboCassandra::Controller::Template.new
  end
  def test_load
    root = '/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/rest/turbo'
    filename = { 'name' => 'place_order.html.erb'}
    response = @template_controller.load root, filename
    assert response.key? :file
  end

  def test_preview
    template = File.read('/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/views/mailer/place_order.html.erb')
    body = {
        file: template,
        filename: 'place_order.html.erb',
        type: 'html'
    }
    response = @template_controller.preview body.to_json
    assert response
  end

  def test_process
    root = '/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/rest/turbo'
    body = {
        action: 'notification',
        email: 'kshakirov@zoral.com.ua',
        password: 'testpassword'
    }
    response = @template_controller.process body.to_json, root
    assert response
  end

  def test_order_process
    root = '/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/rest/turbo'
    body = {
        action: 'order',
        email: 'kshakirov@zoral.com.ua',
        order_id: 100000001
    }
    response = @template_controller.process body.to_json, root
    assert response
  end

  def test_notifcation_template
    root = '/home/kshakirov/git/cassandra/ti_cassandra/sinatra_cassandra/rest/turbo'
    body = {
        action: 'notification',
        notification_code: 'send_user_data',
        email: 'kshakirov@zoral.com.ua',
        data: {
            login: 'kshakirov',
            password: 'test',
            name: 'Kirill Shakirov'

        }
    }
    response = @template_controller.process body.to_json, root
    assert response
  end

end