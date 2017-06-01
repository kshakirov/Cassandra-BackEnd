module TurboCassandra
  module Sync
    module Product
      class Updater
        def initialize elastic_host, index_name, metadata_server
          @product_api = TurboCassandra::API::Product.new
          @index_manager = TurboCassandra::ElasticIndex.new(elastic_host, index_name)
          @updater = TurboCassandra::Sync::Product::Rest.new(metadata_server)
        end

        def rest_update
          @updater.update
        end

        def rest_update_by_name server_name
          @updater.update_by_name server_name
        end

        def rest_update_specific id
          @updater.update_specific id
        end

        def elastic_update product_hashes
          product_hashes.map do |p|
            if p[:action] == 'update'
              product = @product_api.find_by_sku p[:sku]
              unless product.nil?
                @index_manager.add_product product
                puts "PRODUCT [#{p[:sku]} UPDATED IN ELASTIC"
              end
            elsif p[:action] == 'delete'
              begin
                @index_manager.delete_product p[:sku]
                puts "PRODUCT [#{p[:sku]}  DELETED FROM ELASTIC"
              rescue Exception => e
                puts "PRODUCT [#{p[:sku]} ALREADY DELETED FROM ELASTIC"
              end
            end
            p
          end
        end

        def run
          product_hashes = rest_update
          elastic_update product_hashes
        end
        def run_specific id
          product_hash =  rest_update_specific id
          elastic_update product_hash
        end
        def run_by_name server_name
          product_hashes = rest_update_by_name server_name
          elastic_update product_hashes
        end
      end
    end
  end
end