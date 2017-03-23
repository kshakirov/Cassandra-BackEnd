module TurboCassandra
  module Controller
    module ProductAdminWithPrice

      def is_ti_manufacturer? product
        product['manufacturer'] == "Turbo International"
      end

      def prepare_response product, price
        {
            name: product['part_number'],
            sku: product['sku'],
            price: price,
            part_type: product['part_type'],
            quantity: 1,
            tax_percent: 0,
            discount_amount: 0

        }
      end

      def respond_no_price
        {
            error: "This Product has no price"
        }
      end

      def respond_non_ti
        {
            error: "Not in Stock"
        }
      end


      def get_ti_part_admin interchanges
        unless interchanges.nil?
          tis = get_interchanged_products(interchanges)
          tis = tis.select { |i| is_ti_product?(i) }
        end
      end

      def process_non_ti_part product, customer_group_id
        ti_part = get_ti_part_admin(product['interchanges'])
        if not ti_part.nil? and ti_part.first
          ti_part = ti_part.first
          price = @group_price_api.find_by_sku_group_id(ti_part['sku'], customer_group_id)
          if price
            ti_product = prepare_response(ti_part, price)
            ti_product[:oem_part] = product['part_number']
            ti_product
          else
            respond_no_price
          end
        else
          respond_non_ti
        end
      end

      def get_product_with_price sku, customer_group_id
        product = @product_api.find_by_sku(sku)
        price = @group_price_api.find_by_sku_group_id(sku, customer_group_id)
        return product, price
      end

      def _get_admin_product_with_price sku, customer_group_id
        product, price = get_product_with_price(sku, customer_group_id)
        if is_ti_manufacturer? product
          if price
            return prepare_response(product, price)
          else
            return respond_no_price
          end
        else
          process_non_ti_part product, customer_group_id
        end
      end
    end
  end
end