class TcasClient
  def initialize tcas_host
    @tcas_host = "http://" + tcas_host
    puts tcas_host
  end

  def query_interchanges sku
    begin
      interchanges_url = @tcas_host + "/attrsreader/product/#{sku}/interchanges/"
      response = RestClient.get(interchanges_url)
      JSON.parse(response.body)
    rescue Exception => e
      puts e.message
      puts "SKU [#{sku}] PROBLEM"
    end
  end
end
