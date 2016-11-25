require 'sinatra/base'
require 'json'
require 'cassandra'
require 'digest'
require 'jwt'
require 'yaml'
require 'logger'
require 'action_mailer'
require 'active_support'
require 'active_support/all'

require 'prawn'
require 'prawn/table'
require_relative 'lib/sources'
require_relative 'mailer'



class Public < Sinatra::Base

  set :bind, '0.0.0.0'
  set :port, 4700

  configure do
    set :menuBackEnd, TurboCassandra::MenuBackEnd.new
    set :productBackEnd, TurboCassandra::ProductBackEnd.new
    set :loginBackEnd, TurboCassandra::Login.new
    set :orderBackEnd, TurboCassandra::OrderBackEnd.new
  end

  ActionMailer::Base.smtp_settings = {
      :address => "smtp.office365.com",
      :port => '587',
      :authentication => :login,
      :enable_starttls_auto => true,
      :user_name => 'kyrylo.shakirov@zorallabs.com',
       :password => '',
  }
  ActionMailer::Base.view_paths = 'views/'



  before do
    content_type :json
  end

  get '/frontend/menu/manufacturer' do
    settings.menuBackEnd.get_manufacturers
  end


  get '/frontend/menu/part' do
    settings.menuBackEnd.get_parts
  end

  get '/frontend/menu/critical' do
    settings.menuBackEnd.get_critical_parts
  end

  get '/frontend/menu/currency' do
    settings.menuBackEnd.get_currencies
  end

  get '/frontend/menu/product/featured' do
    settings.menuBackEnd.get_featured_product
  end

  get '/frontend/menu/product/new' do
    settings.menuBackEnd.get_new_product
  end

  get '/frontend/menu/manufacturer/filter' do
    settings.menuBackEnd.get_manufacturer_filters
  end

  get '/frontend/menu/standard/filter' do
    settings.menuBackEnd.get_filters
  end

  get '/frontend/menu/standard/header' do
    settings.menuBackEnd.get_headers
  end

  get '/frontend/menu/standard/sorter' do
    settings.menuBackEnd.get_sorters
  end

  get '/frontend/menu/critical/filter' do
    settings.menuBackEnd.get_critical_filters(params[:part_type])
  end

  get '/frontend/menu/critical/header' do
    settings.menuBackEnd.get_critical_headers(params[:part_type])
  end

  get '/frontend/menu/critical/sorter' do
    settings.menuBackEnd.get_critical_sorters(params[:part_type])
  end

  post '/frontend/product' do
    request_payload = JSON.parse request.body.read
    settings.productBackEnd.get_product(request_payload['sku'])
  end


  post '/frontend/customer/login' do
    request_payload = JSON.parse request.body.read
    settings.loginBackEnd.validate_password(request_payload['password'], request_payload['customer_email'])
  end

  post '/frontend/customer/contact_us' do
    request_payload = JSON.parse request.body.read
    email = Mailer.notification request_payload
    email.deliver
  end

  get '/frontend/order/:id/print' do
    content_type 'application/pdf'
    settings.orderBackEnd.print(params[:id].to_i)

  end

end