
class Customer < Sinatra::Base
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies
  config_file '../../config/config.yml'

  use JwtAuth
  use ExceptionHandling
  ActionMailer::Base.smtp_settings = {
      :address => "smtp.office365.com",
      :port => '587',
      :authentication => :login,
      :enable_starttls_auto => true,
      :user_name => 'kyrylo.shakirov@zorallabs.com',
      :password => 'Servantes1',
  }
  ActionMailer::Base.view_paths = 'views/'


  def get_customer_id env_customer
    env_customer.first['id']
  end

  set :rabbit_queue,
      TurboCassandra::Controller::RabbitQueue.
          new(self.send(ENV['TURBO_MODE'])['queue_host'])
  set :queue_name, self.send(ENV['TURBO_MODE'])['queue_name']
  set :stats_queue_name, self.send(ENV['TURBO_MODE'])['stats_queue_name']

  configure do
    set :customerController, TurboCassandra::Controller::Customer.new
    set :orderController, TurboCassandra::Controller::Order.new
    set :groupPriceController, TurboCassandra::Controller::GroupPrice.new
    set :cartController, TurboCassandra::Controller::Cart.new
    set :visitorLog, TurboCassandra::Controller::VisitorLog.
        new(settings.rabbit_queue.connection,
            settings.stats_queue_name)
    set :comparedProductsController, TurboCassandra::Controller::ComparedProducts.new
    set :messageLogController,
        TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection, settings.queue_name)
    set :admin_email, "kyrylo.shakirov@zorallabs.com"
  end


  before do
    content_type :json
  end

  get '/account' do
    scopes = request.env.values_at :scopes
    if  scopes.first.include?('view_prices')
      settings.customerController.get_account(request.env.values_at(:customer))
    else
      halt 403
    end
  end

  get '/order' do
    scopes, customer = request.env.values_at :scopes, :customer
    if scopes.include?('view_prices')
      settings.orderController.get_order_by_customer_id(customer['id'])
    else
      halt 403
    end
  end

  get '/product/:id/price' do
    settings.visitorLog.new_customer_visit(   request, params)
    customer_group = request.env.values_at( :customer).first['group']
    sku = params[:id].to_i
    {
        price:  settings.groupPriceController.get_price(sku, customer_group)
    }

  end

  get '/cart' do
    settings.cartController.get_customer_cart(request.env.values_at :customer)
  end

  get '/cart/product/count' do
    settings.cartController.get_products_count(request.env.values_at :customer)
  end

  put '/cart/currency' do
    settings.cartController.set_currency(request.env.values_at(:customer),
                                                               request.body.read)
  end

  post '/cart/' do
    settings.cartController.update_cart(request.body.read)
  end

  post '/cart/product' do
    settings.cartController.add_product_to_cart(
        request.env.values_at(:customer), request.body.read)
  end

  delete '/cart' do
    settings.cartController.empty_customer_cart(
        request.env.values_at(:customer))
  end

  delete '/cart/product/:id' do
    settings.cartController.delete_product_from_cart(
        request.env.values_at(:customer), params[:id])
  end

  get '/order/new' do
    customer = request.env.values_at :customer
    customer_id = customer.first['id']
    settings.orderController.create_order(customer_id)
  end

  get '/order/:id' do
    settings.orderController.get_order(params[:id].to_i)
  end

  post '/order/save' do
    customer = request.env.values_at :customer
    settings.orderController.save(request.env.values_at(:customer), request.body.read)

  end

  get '/data' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.customerController.get_customer_data customer
  end


  get '/product/viewed' do
    settings.visitorLog.last_5_customer_visits(request)
  end

  put '/account/' do
    settings.customerController.update_account(
        JSON.parse request.body.read)
  end

  put '/account/address/' do
    settings.customerController.update_address(request.body.read)
  end

  put '/account/password/' do
    customer_data = JSON.parse request.body.read
    result = settings.customerController.update_password customer_data
    if result
      200
    else
      401
    end
  end

  get '/compared_product/' do
    customer = request.env.values_at(:customer).first
    settings.comparedProductsController.find_by_customer(customer['id'], customer['group'])
  end

  get '/compared_product/count/' do
    settings.comparedProductsController.count_products(request.env.values_at(:customer))
  end

  delete'/compared_product/' do
    settings.comparedProductsController.delete_all(request.env.values_at(:customer))
  end

  put '/compared_product/:id' do
    customer = request.env.values_at(:customer).first
    payload = {product: params['id'].to_i, customer_id: customer['id']}
    settings.comparedProductsController.update(payload)
  end

  delete '/compared_product/:id' do
    customer = request.env.values_at(:customer).first
    settings.comparedProductsController.delete(customer['id'], params['id'].to_i)
  end

  get '/product/:id/also_bought/' do
    settings.orderController.get_also_bought_products(params['id'], request.env.values_at(:customer))
  end

  post '/order/email' do
    settings.messageLogController.queue_order_task(
        request.body.read)
  end

  after do
    response.body = JSON.dump(response.body)
  end

end
