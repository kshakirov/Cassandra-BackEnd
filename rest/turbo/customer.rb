class JwtAuth

  def initialize app
    @app = app
    @jwt_issuer = 'zoral.com'
    @jwt_secret = 'keepitsecret'
  end

  def call env
    begin
      options = {algorithm: 'HS256', iss: @jwt_issuer}
      bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1)
      payload, header = JWT.decode bearer, @jwt_secret, true, options

      env[:scopes] = payload['scopes']
      env[:customer] = payload['customer']

      @app.call env
    rescue JWT::DecodeError
      [401, {'Content-Type' => 'text/plain'}, ['A token must be passed.']]
    rescue JWT::ExpiredSignature
      [403, {'Content-Type' => 'text/plain'}, ['The token has expired.']]
    rescue JWT::InvalidIssuerError
      [403, {'Content-Type' => 'text/plain'}, ['The token does not have a valid issuer.']]
    rescue JWT::InvalidIatError
      [403, {'Content-Type' => 'text/plain'}, ['The token does not have a valid "issued at" time.']]
    end
  end

end

class Customer < Sinatra::Base
  use JwtAuth

  ActionMailer::Base.smtp_settings = {
      :address => "smtp.office365.com",
      :port => '587',
      :authentication => :login,
      :enable_starttls_auto => true,
      :user_name => 'kyrylo.shakirov@zorallabs.com',
      :password => '',
  }
  ActionMailer::Base.view_paths = 'views/'


  def get_customer_id env_customer
    env_customer.first['id']
  end

  configure do
    set :customerController, TurboCassandra::Controller::Customer.new
    set :orderController, TurboCassandra::Controller::Order.new
    set :groupPriceController, TurboCassandra::Controller::GroupPrice.new
    set :cartController, TurboCassandra::Controller::Cart.new
    set :logBackEnd, TurboCassandra::VisitorLogBackEnd.new
    set :comparedProductsController, TurboCassandra::Controller::ComparedProducts.new
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
    customer = request.env.values_at :customer
    sku = params[:id].to_i
    settings.logBackEnd.new_customer_visit({
                                               customer_id: customer.first['id'],
                                               ip: env['REMOTE_ADDR'],
                                               product: sku
                                           })
    price = settings.groupPriceController.get_price(sku, customer.first['group'])
    {price: price}

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
    order_data = settings.orderController.save(request.env.values_at(:customer), request.body.read)
    customer = settings.customerController.get_account(customer)
    email = Mailer.place_order customer, order_data
    begin
      email.deliver
      {order_id: order_data['order_id'], mailed: true}
    rescue
      {order_id: order_data['order_id'], mailed: false}
    end
  end

  get '/data' do
    scopes, customer = request.env.values_at :scopes, :customer
    settings.customerController.get_customer_data customer
  end


  get '/product/viewed' do
    customer = request.env.values_at :customer
    customer_id = customer.first['id']
    settings.logBackEnd.last5_customer(customer_id)
  end

  put '/account/' do
    settings.customerController.update_account(
        JSON.parse request.body.read)
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

  after do
    response.body = JSON.dump(response.body)
  end

end
