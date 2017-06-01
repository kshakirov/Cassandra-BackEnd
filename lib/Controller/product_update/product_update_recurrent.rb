module TurboCassandra
  module Controller
    class ProductUpdate
      def get_elastic_host
        @elastic_host = @system_data_api.find 'ip', name: 'elastic_instance'
      end

      def get_index_name
        @elastic_index = @system_data_api.find 'id', name: 'elastic_index'
      end

      def get_metdata_host
        @metadata_instance = @system_data_api.find 'ip', name: 'metadata_instance'
      end

      def initialize
        @system_data_api = TurboCassandra::API::SystemData.new
        @elastic_host = @system_data_api.find 'ip', name: 'elastic_instance'
        @elastic_index = @system_data_api.find 'id', name: 'elastic_index'
        @metadata_instance = @system_data_api.find 'ip', name: 'metadata_instance'
        @product_recurrent_update_api = TurboCassandra::API::ProductRecurrentUpdate.new
        @updater = TurboCassandra::Sync::Product::Updater.new @elastic_host, @elastic_index, @metadata_instance

      end

      def all
        @product_recurrent_update_api
      end

      def recurent_update
        products = @updater.run
        products.each do |p|
          @product_recurrent_update_api.log p
        end
        products
      end
    end
  end
end