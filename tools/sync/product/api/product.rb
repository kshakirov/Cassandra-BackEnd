module TurboCassandra
  module Sync
    module Product
      class Rest
        def initialize tcas_client
          @metadata_server = 'timms.turbointernational.com'
          @metadata_server_port = 4568
          @product_api = TurboCassandra::API::Product.new
          @product_batch = TurboCassandra::API::Batch::Product.new
          @tcas_client = tcas_client
        end

        private
        def query_specific skus
          response = RestClient.post("http://#{@metadata_server}:#{@metadata_server_port.to_s}/product/update/specific", skus.to_json)
          JSON.parse response.body
        end

        def exists? sku
          @product_api.find_by_sku(sku)
        end


        def delete_product sku
            @product_api.delete sku
        end


        def prepare_product_data product
          sku = product['sku']
          @product_batch.remove_keys(product)
          @product_batch.prepare_interchanges(product, @tcas_client.query_interchanges(sku))
          @product_batch.prepare_ti_part(product, @tcas_client.query_interchanges(sku))
          @product_batch.parse_critical_attributes(product)
        end

        def process_product product
          if product and product['action'] != 'delete'
            prepare_product_data(product)
            if exists? product['sku']
              @product_api.update product
            else
              @product_api.create(product)
            end
          elsif product and product['action'] == 'delete'
              delete_product  product['sku']
          end
        end

        public
        def update_specific skus
          products = query_specific(skus)
          products.map { |product| process_product(product) }
        end

      end
    end
  end
end
