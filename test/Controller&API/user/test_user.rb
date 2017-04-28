require_relative '../test_helper'

class TestUser < Minitest::Test
  def setup
    @user_api = TurboCassandra::API::User.new
    @user_controller = TurboCassandra::Controller::User.new
    @generator = Cassandra::Uuid::Generator.new
  end

  def test_add
    user = {
       # id: @generator.uuid,
        login: 'kshakirov',
        name: "Kirill Shakirov",
        email: "kshakirov@zoral.com.ua",
        password: "test",
        must_change: true,
        authentication_node: 'Internal'
    }
    #res = @user_api.add_user user
    @user_controller.create_user user.to_json
    refute_nil res
  end

  def test_all
    all = @user_api.all
    assert_true 1, all.size
  end

  def test_delete
    @user_api.delete_user 'kshakirov'
  end

  def test_find
    user = @user_api.find_user_by_login 'kshakirov'
    assert_instance_of Array, user
  end

  def test_find_controller
    params = {'login' => 'kshakirov'}
    user = @user_controller.get_user params
    assert_equal 'Kirill Shakirov', user['name']
  end

  def test_all_controller
    all = @user_controller.get_users_list
    assert_equal 4, all.size
  end

  def test_delete_controller
    id = Cassandra::Uuid.new('9ba30fa5-fe93-44b0-ae4e-28cdcdc6e66d')
    @user_api.delete_user id
  end


end