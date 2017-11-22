class PartRestClient

  def initialize metadata_server, metadata_server_port=4568
    @metadata_server = metadata_server
    @metadata_server_port = metadata_server_port
    @product_api = TurboCassandra::API::Product.new
    @range = Random.new
  end

  private
  def base_query url, payload
    begin
      tries = 5
      RestClient.post(url, payload)
    rescue StandardError => e
      if (tries -= 1) > 0
        time_to_sleep = @range.rand(20)
        puts "Failed Payload #{payload}  Attempt [#{tries.to_s}], Sleeping #{time_to_sleep} sec ... "
        sleep time_to_sleep
        retry
      else
        puts "Giving up, Payload [#{payload}] "
      end
    end
  end

  public
  def query_inactive
    url = "http://#{@metadata_server}:#{@metadata_server_port}/product/status/inactive"
    payload = []
    response = base_query url, payload
    unless response.nil?
      response = JSON.parse response.body, {
          :symbolize_names => true
      }
      response[:inactive]
    end
  end

  def query_active
    url = "http://#{@metadata_server}:#{@metadata_server_port}/product/status/active"
    payload = []
    response = base_query url, payload
    unless response.nil?
      response = JSON.parse response.body, {
          :symbolize_names => true
      }
      response[:active]
    end
  end

  def query_bulk skus
    url = "http://#{@metadata_server}:#{@metadata_server_port}/product/update/bulk"
    payload = skus.to_json
    response = base_query url, payload
    unless response.nil?
      JSON.parse response.body
    end
  end

end