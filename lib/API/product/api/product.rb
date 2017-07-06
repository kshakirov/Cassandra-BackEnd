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

      def prepare_prod_part_number product
        {
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
        @generator = Cassandra::Uuid::Generator.new
      end

      def find_by_sku sku
        product =TurboCassandra::Model::Product.find sku
        begin
          product.to_hash
        rescue
          nil
        end
      end

      def find_by_part_number part_number
        part_number = TurboCassandra::Model::ProductPartNumber.find part_number
        unless part_number.nil?
          find_by_sku part_number.sku
        end
      end

      def find sku
        TurboCassandra::Model::Product.find sku
      end

      def where_skus skus
        TurboCassandra::Model::Product.find_in_by sku: skus
      end

      def each &block
        @product_model.each &block
      end

      def paginate paging_state, page_size
        paging_params = {
            'paging_state' => paging_state,
            'page_size' => page_size
        }
        TurboCassandra::Model::Product.paginate paging_params
      end

      def create product_hash
        product_hash['created_at'] =@generator.now
        product = TurboCassandra::Model::Product.new product_hash
        product.save
        product_created_at = TurboCassandra::Model::ProductCreatedAtinsert.new(prepare_product_created_at(product_hash))
        product_created_at.save
        product_part_number = TurboCassandra::Model::ProductPartNumber.new(prepare_prod_part_number(product_hash))
        product_part_number.save
      end

      def update product_hash
        product = TurboCassandra::Model::Product.new product_hash
        product.save
      end

      def delete sku
        product_2_delete = TurboCassandra::Model::Product.find(sku).to_hash
        if product_2_delete
          manufacturer, part_type, created_at = prepare_product_created_2_del(product_2_delete)
          TurboCassandra::Model::ProductCreatedAt.delete manufacturer, part_type, created_at
          TurboCassandra::Model::ProductPartNumber.delete product_2_delete['part_number']
          TurboCassandra::Model::Product.delete sku
        end
      end

    end
  end
end