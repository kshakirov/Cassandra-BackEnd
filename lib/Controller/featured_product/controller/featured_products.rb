module TurboCassandra
  module Controller
    class FeaturedProduct
      def initialize
        @product_api = TurboCassandra::API::Product.new
        @featured_product_api = TurboCassandra::API::FeaturedProduct.new
      end

      private

      def get_next_order
        @featured_product_api.next_order
      end

      def populate_featured_product product
        {
            sku: product['sku'],
            ord: get_next_order,
            visible: false,
            part_number: product['part_number']
        }
      end



      def _add_product sku
        product = @product_api.find_by_sku(sku)
        unless product.nil?
          @featured_product_api.create(populate_featured_product(product))
          return {
              result: true
          }
        end
        {
            result: false
        }
      end

      public
      def get_admin_list
        @featured_product_api.all
      end

      def update_featured_product body
        product = JSON.parse body
        @featured_product_api.update product
      end

      def add_product params
        sku = params['id'].to_i
        _add_product(sku)
      end

      def delete_product params
        sku = params['id'].to_i
        @featured_product_api.delete sku
      end
    end
  end
end