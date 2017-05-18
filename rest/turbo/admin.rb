class AdminLogin < Sinatra::Base
  use ExceptionHandling
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies
  config_file '../../config/config.yml'

  set :rabbit_queue,
      TurboCassandra::Controller::RabbitQueue.
          new(self.send(ENV['TURBO_MODE'])['queue_host'])
  set :active_directory_host, self.send(ENV['TURBO_MODE'])['active_directory']
  set :adminLoginController, TurboCassandra::Controller::AdminLogin.new(settings.active_directory_host)
  set :messageLogController, TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection)

  before do
    content_type :json
  end

  post '/login' do
    settings.adminLoginController.authenticate_admin(request.body.read)
  end

  post '/reset' do
    password_data = settings.adminLoginController.reset_password(request.body.read)
    settings.messageLogController.queue_user_reset_notification password_data


  end

  after do
    response.body = JSON.dump(response.body)
  end
end


class Admin < Sinatra::Base

  use JwtAuth
  use ExceptionHandling
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies
  config_file '../../config/config.yml'

  set :public_folder, Proc.new { File.join(root.gsub("rest/turbo", ''), "views") }
  set :rabbit_queue,
      TurboCassandra::Controller::RabbitQueue.
          new(self.send(ENV['TURBO_MODE'])['queue_host'])


  configure do
    set :customerController, TurboCassandra::Controller::Customer.new
    set :currencyController, TurboCassandra::Controller::Currency.new
    set :featuredProductController, TurboCassandra::Controller::FeaturedProduct.new
    set :newProductController, TurboCassandra::Controller::NewProduct.new
    set :product_controller, TurboCassandra::Controller::Product.new
    set :orderController, TurboCassandra::Controller::Order.new
    set :attributeController, TurboCassandra::Controller::Attribute.new
    set :attributeSetController, TurboCassandra::Controller::AttributeSet.new
    set :adminController, TurboCassandra::Controller::Admin.new
    set :messageLogController, TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection)
    set :admin_email, "kyrylo.shakirov@zorallabs.com"
    set :productController, TurboCassandra::Controller::Product.new
    set :productCreatedAtController, TurboCassandra::Controller::ProductCreatedAt.new
    set :groupPriceController, TurboCassandra::Controller::GroupPrice.new
    set :menuController, TurboCassandra::Controller::Menu::Main.new
    set :templateController, TurboCassandra::Controller::Template.new
    set :customerGroupController, TurboCassandra::Controller::CustomerGroup.new
    set :userController, TurboCassandra::Controller::User.new
    set :adminEmailController, TurboCassandra::Controller::AdminEmail.new
  end


  before do
    content_type :json
  end


  get '/manufacturer/' do
    settings.menuController.get_manufacturers
  end


  get '/part_type/' do
    settings.menuController.get_parts
  end


  get '/customer/' do
    settings.customerController.get_all
  end

  get '/customer/:id' do
    settings.customerController.get_account(params)
  end

  get '/customer/:id/order/' do
    settings.orderController.find_all_by_customer(params[:id].to_i)
  end

  get '/customer/order/:id' do
    settings.orderController.find(params[:id].to_i)
  end

  get '/attribute/' do
    settings.attributeController.find_all
  end

  post '/attribute/' do
    settings.attributeController.create(request.body.read)
  end

  get '/attribute/:code' do
    settings.attributeController.find_by_code(params)
  end

  post '/attribute/list/' do
    settings.attributeController.find_by_codes(request.body.read)
  end

  get '/attribute_set/' do
    settings.attributeSetController.get_attribute_sets_list
  end

  get '/attribute_set/:code' do
    settings.attributeSetController.get_attribute_set('code', params[:code])
  end

  post '/attribute_set/' do
    request_payload = JSON.parse request.body.read
    settings.attributeSetController.update_critical_property(request_payload)
  end

  post '/customer/password/reset/' do
    settings.adminController.reset_password(request.body.read)
  end

  put '/customer/password/change/' do
    settings.adminController.change_password(request.body.read)
  end

  post '/customer/:id/order/new/' do
    settings.orderController.create_order_by_admin(request.body.read)
  end

  put '/customer/new/' do
    settings.adminController.create_new_customer(request.body.read)
  end

  post '/customer/new/' do
    settings.adminController.create_new_customer_by_admin(request.body.read)
  end

  post '/message/' do
    settings.messageLogController.log_task_complete(request.body.read)
  end

  post '/message/paginate' do
    settings.messageLogController.paginated(request.body.read,)
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

  get '/shipment/order/:order_id' do
    settings.orderController.find_shipment_only_by_order_id(params)
  end

  post '/product/paginate/' do
    settings.productCreatedAtController.where(request.body.read)
  end

  get '/product/:id' do
    settings.productController.get_admin_product(params)
  end

  get '/customer/group/:customer_group_id/product/:id' do
    settings.productController.get_admin_prouct_with_price(params)
  end

  get '/price/:id/group/' do
    settings.groupPriceController.get_prices(params)
  end

  get '/featured_product/' do
    settings.featuredProductController.get_admin_list
  end

  get '/new_product/' do
    settings.newProductController.get_admin_list
  end

  get '/featured_product/:id' do
    settings.featuredProductController.add_product params
  end

  get '/new_product/:id' do
    settings.newProductController.add_product params
  end

  delete '/featured_product/:id' do
    settings.featuredProductController.delete_product params
  end

  post '/featured_product/' do
    settings.featuredProductController.update_featured_product(
        request.body.read)
  end

  delete '/new_product/:id' do
    settings.newProductController.delete_product params
  end

  post '/new_product/' do
    settings.newProductController.update_new_product(
        request.body.read)
  end

  get '/currency/current' do
    settings.currencyController.all
  end

  post '/currency/current' do
    settings.currencyController.update_all(request.body.read)
  end

  get '/template/:name' do
    settings.templateController.load(params)
  end

  put '/template/preview' do
    settings.templateController.preview(request.body.read)
  end

  post '/template/' do
    settings.templateController.save(request.body.read)
  end

  post '/template/process' do
    settings.templateController.process(request.body.read)
  end

  get '/customer_group/' do
    settings.customerGroupController.all
  end

  put '/customer_group/' do
    settings.customerGroupController.update_group(request.body.read)
  end

  post '/profile' do
    settings.userController.get_profile(request.env)
  end

  get '/profile/user/:id/image' do
    content_type 'image/jpeg'
    settings.userController.get_profile_image(params)
  end
  get '/admin_email/' do
    settings.adminEmailController.all
  end

  put '/admin_email/' do
    settings.adminEmailController.update(request.body.read)
  end

  after do
    unless request.path_info.include? "image"
      response.body = JSON.dump(response.body)
    end
  end


end