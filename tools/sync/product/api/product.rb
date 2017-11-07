module TurboCassandra
  module Sync
    module Product
      class Rest
        def initialize metadata_server, metadata_server_port=4568
          @metadata_server = metadata_server
          @metadata_server_port = metadata_server_port
          @product_api = TurboCassandra::API::Product.new
          @product_batch = TurboCassandra::API::Batch::Product.new
        end

        private
        def query_specific skus
          response = RestClient.post("http://#{@metadata_server}:#{@metadata_server_port.to_s}/product/update/specific", skus.to_json)
          JSON.parse response.body
        end


        def get_interchanged_products product
          interchanges = product['interchanges']
          unless interchanges.nil?
            return  interchanges.map do |interchange|
              @product_api.find_by_sku interchange
            end
          end
          []
        end

        def query_update
          response = RestClient.get("http://#{@metadata_server}:#{@metadata_server_port.to_s}/product/update/")
          JSON.parse response.body
        end

        def query_update_by_name server_name
          response = RestClient.get("http://#{@metadata_server}:#{@metadata_server_port.to_s}/product/update/#{server_name}")
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
          @product_batch.prepare_interchanges(product)
          @product_batch.parse_critical_attributes(product)
          @product_batch.derive_name(product)
        end

        def return_operation_result action,  sku
          {
              sku: sku,
              action: action
          }
        end

        def process_product product
          begin
          action = product['action'] if product
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
          return_operation_result(action, product['sku']) if product
          rescue StandardError => e
            p product
            puts e.message
            exit
          end
        end

        public
        def update_specific skus
          products = query_specific([skus.to_i])
          products.map { |product| process_product(product) }
        end

        def update_specific_array skus

          products = query_specific(skus)
          products.map { |product| process_product(product) }
        end

        def update
          products = query_update
          products.map{|product| process_product(product)}
        end
        def update_by_name server_name
          products = query_update_by_name server_name
          products.map{|product| process_product(product)}
        end
      end
    end
  end
end
