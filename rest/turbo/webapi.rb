require_relative '../../lib/WebAPI/web_source'
class WebAPI < Sinatra::Base

  #use JwtAuth

  configure do
    set :attributeWebAPI, TurboCassandra::WebAPI::Attribute::Attribute.new
    set :attributeTypeWebAPI, TurboCassandra::WebAPI::AttributeType::AttributeType.new

  end


  before do
    content_type :json
  end

  get '/products/attributes/types' do
    settings.attributeTypeWebAPI.get
  end

  get '/products/attributes/:attribute_code' do
    settings.attributeWebAPI.get(params)
  end

  delete '/products/attributes/:attribute_code' do
    settings.attributeWebAPI.delete(params)
  end

  post '/products/attributes' do
    settings.attributeWebAPI.create(request.body.read)
  end

  post '/integration/admin/token' do
    "testingToken333"
  end

  after do
    unless request.path_info.include? "token"
      response.body = JSON.dump(response.body)
    end
  end


end