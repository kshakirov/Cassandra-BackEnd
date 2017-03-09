module TurboCassandra
  module Controller
    module AlsoBought
      private

      def derive_name sku, name
        if name.nil? or name.size ==0
         return  "Product Number [#{sku}]"
        end
        name
      end

      def _get_also_bought_products sku
        products = @order.get_also_bought_products(sku)
        products.delete_if{|p| p['sku'] == sku}
        products.map do  |p|
          {
              sku: p['sku'],
              name: derive_name(p['sku'], p['name'])
          }
        end
      end

      public
      def get_also_bought_products sku
        _get_also_bought_products(sku.to_i)
      end

    end
  end
end