module TurboCassandra
  module Controller
    module ProductAdmin

      def admin_prepare_product product
        if product.key? 'critical_decimal' and not product['critical_decimal'].nil?
          product['critical'] = add_critical_attributes(product)
        end
        unless is_ti_product? product
          product['ti_part_sku'], product['ti_part_number'] = add_ti_part_attributes(product)
        end
        prepare_application(product)
        product
      end


      def is_integer? sku
        begin
          Integer(sku)
        rescue
          false
        end
      end


      def get_product_ambigous product, sku
        if not product.nil?
          if  product['sku'] == is_integer?(product['part_number'])
              @product_api.find_by_part_number(sku.to_s)
          else
             product
          end
        else
            @product_api.find_by_part_number(sku)
        end

      end

      def get_by_sku_or_part_nubmer sku
        possible_sku = is_integer? sku
        if possible_sku
          get_product_ambigous(@product_api.find_by_sku(possible_sku), sku)
        else
          @product_api.find_by_part_number sku
        end
      end

      def _admin_get_product sku
        product = get_by_sku_or_part_nubmer sku
        unless product.nil?
          admin_prepare_product product
        end
      end


    end
  end
end