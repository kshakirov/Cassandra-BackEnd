class SuperUser < Sinatra::Base

  use JwtAuth
  use ExceptionHandling
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies
  config_file '../../config/config.yaml'
  set :rabbit_queue,
      TurboCassandra::Controller::RabbitQueue.
          new(self.send(ENV['TURBO_MODE'])['queue_host'])


  configure do
    set :userController, TurboCassandra::Controller::User.new
    set :authNodeController, TurboCassandra::Controller::AuthenticationNode.new
    set :messageLogController, TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection)
  end


  set(:clearance) { |value|
    condition {
      group = request.env.values_at :group
      if group.first == 'superuser'
        true
      else
        raise "You Are Not Authorized to View This Page"
      end
    }
  }


  before do
    content_type :json
  end

  get '/user/', :clearance => true do
    settings.userController.get_users_list
  end

  get '/user/:login' do
    settings.userController.get_user params
  end

  post '/user/' do
    body = JSON.parse request.body.read
    settings.userController.create_user body
  end

  post '/user/notify' do
    body = JSON.parse request.body.read
    password = body['password']
    settings.userController.create_user body
    body['password'] = password
    settings.messageLogController.queue_user_notification body
  end

  put '/user/:id' do
    body = JSON.parse request.body.read
    settings.userController.update_user(body)
  end

  put '/user/:id/notify' do
    body = JSON.parse request.body.read
    password = body['password']
    settings.userController.update_user body
    body['password'] = password
    settings.messageLogController.queue_user_notification(body)
  end

  delete '/user/:id' do
    settings.userController.delete_user params
  end

  get '/authentication_node/', :clearance => true do
    settings.authNodeController.all
  end

  post '/authentication_node/', :clearance => true do
    settings.authNodeController.add_node request.body.read
  end

  get '/authentication_node/:name', :clearance => true do
    settings.authNodeController.get_node params
  end
  delete '/authentication_node/:name', :clearance => true do
    settings.authNodeController.delete params
  end


  not_found do
    403
  end


  after do
    response.body = JSON.dump(response.body)
  end

end