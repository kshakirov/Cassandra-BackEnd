require_relative '../../lib/WebAPI/web_source'
class WebAPI < Sinatra::Base

  use JwtAuth

  configure do
    set :attributeWebAPI, TurboCassandra::WebAPI::Attribute.new

  end


  before do
    content_type :json
  end

  get '/products/attributes/' do
    settings.customerController.get_all
  end

  post '/products/attributes/' do
    settings.customerController.get_all
  end



  after do
    response.body = JSON.dump(response.body)
  end


end