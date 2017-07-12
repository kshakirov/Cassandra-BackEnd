require 'sinatra/base'
require 'sinatra/config_file'
require "sinatra/cookies"
require 'json'
require 'cassandra'
require 'digest'
require 'jwt'
require 'yaml'
require 'logger'
require "march_hare"
require 'action_mailer'
require 'active_support'
require 'active_support/all'
require 'action_view'
require 'securerandom'
require 'active_directory'
require 'prawn'
require 'prawn/table'
require 'erb'
require "base64"
require 'carmen'
require_relative '../../lib/sources'
require_relative 'jwt_auth'
require_relative 'exception_handling'
require_relative 'mailer'
require 'multi_json'


class BigDecimal

  def to_json(options = nil) #:nodoc:
    if finite?
      self.to_s
    else
      NilClass::AS_JSON
    end
  end
end


class Public < Sinatra::Base
  use ExceptionHandling
  register Sinatra::ConfigFile
  helpers Sinatra::Cookies
  config_file '../../config/config.yml'
  set :rabbit_queue,
      TurboCassandra::Controller::RabbitQueue.
          new(self.send(ENV['TURBO_MODE'])['queue_host'])
  set :queue_name, self.send(ENV['TURBO_MODE'])['queue_name']
  set :stats_queue_name, self.send(ENV['TURBO_MODE'])['stats_queue_name']
  set :port, 4700


  configure do
    set :menuController, TurboCassandra::Controller::Menu::Main.new
    set :productController, TurboCassandra::Controller::Product.new
    set :loginController, TurboCassandra::Controller::Login.new
    set :orderController, TurboCassandra::Controller::Order.new
    set :visitorLog, TurboCassandra::Controller::VisitorLog.new(
        settings.rabbit_queue.connection,  settings.stats_queue_name)
    set :messageLogController,
        TurboCassandra::Controller::MessageLog.new(settings.rabbit_queue.connection,
                                                   settings.queue_name)
    set :md5, Digest::MD5.new
  end


  before do
    content_type :json
  end

  get '/frontend/menu/manufacturer' do
    settings.menuController.get_manufacturers
  end


  get '/frontend/menu/part' do
    settings.menuController.get_parts
  end

  get '/frontend/menu/critical' do
    settings.menuController.get_critical_parts
  end

  get '/frontend/menu/currency' do
    settings.menuController.get_currencies
  end

  get '/frontend/menu/product/featured' do
    settings.menuController.get_featured_product
  end

  get '/frontend/menu/product/new' do
    settings.menuController.get_new_product
  end

  get '/frontend/menu/manufacturer/filter' do
    settings.menuController.get_manufacturer_filters
  end

  get '/frontend/menu/part_type/filter' do
    settings.menuController.get_part_type_filters
  end

  get '/frontend/menu/standard/filter' do
    settings.menuController.get_filters
  end

  get '/frontend/menu/standard/header' do
    settings.menuController.get_headers(params[:part_type])
  end

  get '/frontend/menu/standard/sorter' do
    settings.menuController.get_sorters
  end

  get '/frontend/menu/critical/filter' do
    settings.menuController.get_critical_filters(params[:part_type])
  end

  get '/frontend/menu/critical/header' do
    settings.menuController.get_critical_headers(params[:part_type])
  end

  get '/frontend/menu/critical/sorter' do
    settings.menuController.get_critical_sorters(params[:part_type])
  end

  post '/frontend/product' do
    payload = JSON.parse request.body.read
    settings.visitorLog.new_visit(request)
    settings.productController.get_product(payload['sku'])
  end


  post '/frontend/customer/login' do
    request_payload = JSON.parse request.body.read
    settings.loginController.validate_password(request_payload['password'], request_payload['customer_email'])
  end

  post '/frontend/customer/contact_us' do
    request_payload = JSON.parse request.body.read
    email = Mailer.notification request_payload
    email.deliver
  end


  get '/frontend/product/viewed' do
      settings.visitorLog.last_5_visits(request)
  end


  get '/frontend/order/:id/print' do
    content_type 'application/pdf'
    settings.orderController.print(params[:id].to_i)
  end

  get '/frontend/visitor/id/' do
    {
        visitor_id: SecureRandom.uuid
    }.to_json
  end

  post '/frontend/customer/password/reset/' do
    settings.messageLogController.queue_password_reset_task(
        request.body.read)
  end

  post '/frontend/customer/new/' do
    settings.messageLogController.queue_new_customer_task(
        request.body.read)
  end


  after  do
    unless  request.path_info.include?  "print"
      response.body = JSON.dump(response.body)
    end
  end

end