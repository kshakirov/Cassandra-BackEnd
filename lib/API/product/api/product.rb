module TurboCassandra
  module API
    class Product
      private

      def prepare_product_created_at product
        {
            manufacturer: product['manufacturer'],
            part_type: product['part_type'],
            created_at: product['created_at'],
            part_number: product['part_number'],
            sku: product['sku']
        }
      end

      def prepare_product_created_2_del product
        return product['manufacturer'], product['part_type'],
            product['created_at']
      end

      public

      def initialize
        @product_model = TurboCassandra::Model::Product.new
        @featured_product_model = TurboCassandra::Model::FeaturedProduct.new
        @new_product_model = TurboCassandra::Model::NewProduct.new
        @product_created_at_model = TurboCassandra::Model::ProductCreatedAt.new
        @generator = Cassandra::Uuid::Generator.new
      end

      def find_by_sku sku
        @product_model.find [sku]
      end

      def where_skus skus
        @product_model.where skus
      end

      def each &block
        @product_model.each &block
      end

      def paginate paging_state, page_size
        @product_model.paginate paging_state, page_size
      end

      def create product_hash
        product_hash['created_at'] =@generator.now
        @product_model.insert product_hash
        @product_created_at_model.insert(prepare_product_created_at(product_hash))
      end

      def update product_hash
        @product_model.insert product_hash
      end

      def delete sku
        product_2_delete = @product_model.find([sku])
        if product_2_delete
          manufacturer, part_type, created_at = prepare_product_created_2_del(product_2_delete)
          @product_created_at_model.delete(manufacturer, part_type, created_at)
          @product_model.delete sku
          @featured_product_model.delete sku
          @new_product_model.delete sku
        end
      end

    end
  end
end