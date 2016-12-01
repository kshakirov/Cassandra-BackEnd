module TurboCassandra
  class ElasticIndex
    def initialize host= '10.1.3.16'
      @client = Elasticsearch::Client.new(host: host , log: true)
      @client.transport.reload_connections!
      @product_mapper = TurboCassandra::EsProductMapping.new
      @application_transformer = TurboCassandra::EsApplicationTransformer.new
      @application_mapper = TurboCassandra::EsApplicationMapping.new
      @product_transformer = TurboCassandra::EsProductTransformer.new
    end

    def create name
      unless @client.indices.exists? index: name
        @client.indices.create index: name
      end
    end
    def delete name
      if @client.indices.exists? index: name
        @client.indices.delete  index: name
      end
    end
    def put_mapping name, type
      @client.indices.put_mapping index: name, type: type, body: @product_mapper.create
    end

    def put_application_mapping name, type
      @client.indices.put_mapping index: name, type: type, body: @application_mapper.create_application_mapping
    end

    def put_critical_mapping name, type, attrs
      @client.indices.put_mapping index: name, type: type, body: @product_mapper.create_criticals(attrs)
    end

    def add_product product
      document = @product_transformer.run product
      @client.index  index: 'magento_product', type: 'product',  id: product['sku'],  body: document
    end

    def add_application application
      document = @application_transformer.run application
      @client.index  index: 'magento_product', type: 'application',  id: document[:id],  body: document
    end

  end
end
