class Admin < Sinatra::Base

  use JwtAuth
  set :rabbit_queue,  TurboCassandra::Controller::RabbitQueue.new("localhost")

  configure do
    set :customerController, TurboCassandra::Controller::Customer.new
    set :product_controller, TurboCassandra::Controller::Product.new
    set :loginBackEnd, TurboCassandra::Login.new
    set :orderController, TurboCassandra::Controller::Order.new
    set :attributeBackEnd, TurboCassandra::AttributeBackEnd.new
    set :attributeSetBackEnd, TurboCassandra::AttributeSetBackEnd.new
    set :adminController, TurboCassandra::Controller::Admin.new
    set :messageLogController,TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection)
    set :admin_email, "kyrylo.shakirov@zorallabs.com"
  end


  before do
    content_type :json
  end

  get '/customer/' do
    settings.customerController.get_all
  end

  get '/customer/:id' do
    settings.customerController.get_account(params['id'].to_i)
  end

  get '/customer/:id/order/' do
    settings.orderController.find_all_by_customer(params[:id].to_i)
  end

  get '/customer/order/:id' do
    settings.orderController.find(params[:id].to_i)
  end

  get '/attribute/' do
    settings.attributeBackEnd.get_attributes_list
  end

  get '/attribute_set/' do
    settings.attributeSetBackEnd.get_attribute_sets_list
  end

  get '/attribute_set/:code' do
    settings.attributeSetBackEnd.get_attribute_set('code', params[:code])
  end

  post '/attribute_set/' do
    request_payload = JSON.parse request.body.read
    settings.attributeSetBackEnd.update_critical_property(request_payload)
  end

  put '/customer/password/reset/' do
    request_payload = JSON.parse request.body.read
    settings.adminController.reset_password(request_payload['email'])
  end

  put '/customer/new/' do
    request_payload = JSON.parse request.body.read
    settings.adminController.create_new_customer(request_payload['email'])
  end

  post '/message/' do
    settings.messageLogController.add_password_sent_msg(request.body.read,
                                                   settings.admin_email)
  end

  get '/order/' do
    settings.orderController.all
  end

  get '/shipment/' do
    settings.orderController.all_shipments
  end

  get '/shipment/:id/order/:order_id' do
    settings.orderController.find_shipment_by_order_id(params)
  end

  get '/order/:id' do

  end


  after do
    response.body = JSON.dump(response.body)
  end


end