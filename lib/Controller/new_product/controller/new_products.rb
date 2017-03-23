module TurboCassandra
  module Controller
    class NewProduct
      def initialize
        @product_api = TurboCassandra::API::Product.new
        @new_product_api = TurboCassandra::API::NewProduct.new
      end

      private
      def populate_featured_product product
        {
            sku: product['sku'],
            ord: 100,
            visible: false,
            part_number: product['part_number']

        }
      end

      def _create_admin_response new_products
        new_products.sort_by { |p| p[:order] }
      end

      def _add_product sku
        product = @product_api.find_by_sku(sku)
        if not product.nil?
          @new_product_api.create(populate_featured_product(product))
         return  {
             result: true
         }
        end
        {
            result: false
        }
      end

      public
      def get_admin_list
        @new_product_api.all
      end

      def update_new_product body
        product = JSON.parse body
        @new_product_api.update product
      end

      def add_product params
        sku = params['id'].to_i
        _add_product(sku)
      end

      def delete_product params
        sku = params['id'].to_i
        @new_product_api.delete sku
      end
    end
  end
end