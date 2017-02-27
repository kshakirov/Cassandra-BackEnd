module TurboCassandra
  module Controller
    class Product
      include TurboCassandra::Controller::CriticalDims
      public
      def initialize
        @product_api = TurboCassandra::API::Product.new
        @attribute = Attribute.new
      end

      private

      def _get_product sku
        sku = sku.to_i
        product = @product_api.find_by_sku(sku).first
        if product.key? 'critical_decimal' and not product['critical_decimal'].nil?
          product['critical'] = add_critical_attributes(product)
        end
        product
      end

      def _get_products skus
        skus = skus.map { |sku| sku.to_i }
        products = @product_api.where_skus skus
        products.map { |p|
          if p.key? 'critical_decimal' and not p['critical_decimal'].nil?
            p['critical'] = add_critical_attributes(p)
          end
          p
        }
      end

      public
      def get_product sku
        _get_product(sku)
      end

      def get_products skus
        _get_products(skus)
      end
    end
  end
end