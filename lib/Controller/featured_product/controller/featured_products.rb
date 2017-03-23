module TurboCassandra
  module Controller
    class FeaturedProduct
      def initialize
        @product_api = TurboCassandra::API::Product.new
        @featured_product_api = TurboCassandra::API::FeaturedProduct.new
      end

      private
      def _get_admin_scheleton featured_product, product
        {
            sku: product['sku'],
            part_number: product['part_number'],
            part_type: product['part_type'],
            order: featured_product['ord'],
            visible: featured_product['visible']
        }
      end

      def populate_featured_product product
        {
            sku: product['sku'],
            ord: 100,
            visible: false
        }
      end

      def _create_admin_response featured_products, products
        featured_products = products.each_with_index.map { |p, index| _get_admin_scheleton(featured_products[index], p) }
        featured_products.sort_by { |p| p[:order] }
      end

      def _add_product sku
        product = @product_api.find_by_sku(sku)
        if not product.nil?
          @featured_product_api.create(populate_featured_product(product))
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
        featured_product_ids = @featured_product_api.all
        featured_product_ids.sort_by! { |fp| fp['sku'] }
        products = @product_api.where_skus(featured_product_ids.map { |fp| fp['sku'] })
        products.sort_by! { |p| p['sku'] }
        _create_admin_response(featured_product_ids, products)
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