class Admin < Sinatra::Base

  use JwtAuth


  configure do
    set :customerBackEnd, TurboCassandra::CustomerBackEnd.new
    set :productBackEnd, TurboCassandra::ProductBackEnd.new
    set :loginBackEnd, TurboCassandra::Login.new
    set :orderBackEnd, TurboCassandra::OrderBackEnd.new
    set :attributeBackEnd, TurboCassandra::AttributeBackEnd.new
    set :attributeSetBackEnd, TurboCassandra::AttributeSetBackEnd.new
  end



  before do
    content_type :json
  end

  get '/customer/' do
    settings.customerBackEnd.get_list
  end

  get '/customer/:id' do
    settings.customerBackEnd.get_customer_info(params['id'].to_i)
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

end