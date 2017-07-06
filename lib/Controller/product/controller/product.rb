module TurboCassandra
  module Controller
    class Product
      attr_accessor :product_api, :group_price_api
      include TurboCassandra::Controller::CriticalDims
      include TurboCassandra::Controller::TiPart
      include ProductAdminWithPrice
      include ProductAdmin
      include Pagination
      include ProductApplication

      def initialize
        @product_api = TurboCassandra::API::Product.new
        @attribute = TurboCassandra::API::Attribute.new
        @group_price_api = TurboCassandra::API::GroupPrice.new

      end

      private

      def is_ti_product?  product
        product['manufacturer'] == 'Turbo International'
      end

      def _get_product sku
        sku = sku.to_i
        product = @product_api.find_by_sku(sku)
        if product.key? 'critical_decimal' and not product['critical_decimal'].nil?
          product['critical'] = add_critical_attributes(product)
        end
        unless  is_ti_product? product
          product['ti_part_sku'], product['ti_part_number'] = add_ti_part_attributes(product)
        end
        prepare_application(product)
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

      def get_admin_product(params)
        sku = params['id']
        _admin_get_product(sku)
      end

      def get_admin_prouct_with_price params
        _get_admin_product_with_price(params['id'].to_i, params['customer_group_id'])
      end

    end
  end
end