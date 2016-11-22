class Admin < Sinatra::Base

  use JwtAuth


  configure do
    set :customerBackEnd, TurboCassandra::CustomerBackEnd.new
    set :productBackEnd, TurboCassandra::ProductBackEnd.new
    set :loginBackEnd, TurboCassandra::Login.new
    set :orderBackEnd, TurboCassandra::OrderBackEnd.new
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
end