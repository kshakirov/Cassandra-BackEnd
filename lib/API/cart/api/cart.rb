module TurboCassandra
  module API
    class Cart
      extend Forwardable

      def initialize
        config = TurboCassandra::System::Config.instance
        @scale = config.get_cart_scale
      end

      private
      def create customer_id
        data = {
            id: customer_id,
            currency: 'USD',
            customer_id: customer_id
        }
        cart =TurboCassandra::Model::Cart.new data
        cart.save
        cart
      end

      def is_product_in_cart? items, product
        if items.nil?
          false
        else
          items.key? product['sku']
        end
      end


      def get_subtotal price, qty
        subtotal = price * qty
        subtotal = subtotal.round(@scale['subtotal'])
        subtotal.to_s
      end

      def scale_subtotal cart
          cart.items.each do |sku,value|
            cart.items[sku]['subtotal'] = BigDecimal.new( cart.items[sku]['subtotal']).
                round(@scale['subtotal'],BigDecimal::EXCEPTION_NaN).to_s
          end
      end

      def change_qty items, product, qty
        item = items[product['sku']]
        item['qty'] = (item['qty'].to_i + qty).to_s
        item['subtotal'] = get_subtotal(BigDecimal( item['unit_price']), item['qty'].to_i)
        items
      end

      def prepare_product_item product, price, qty
        item_hash = {}
        item_content = {}
        if not product['ti_part_sku'].nil?
          item_hash[product['ti_part_sku']] = item_content
          item_content['ti_part'] = product['ti_part_number']
          item_content['oem_part'] = product['part_number']
          item_content['oem_part_sku'] = product['sku'].to_s

        else
          item_hash[product['sku']] = item_content
          item_content['ti_part'] = product['part_number']
        end
        item_content['part_type'] =product['part_type']
        item_content['unit_price'] =price.to_s
        item_content['qty'] =qty.to_s
        item_content['subtotal'] = get_subtotal(price, qty)
        item_hash
      end

      def merge_cart_products items, product_hash
        if items.nil?
          items = {}
        end
        sku = product_hash.keys.first
        items[sku] = product_hash[sku]
        items
      end

      def _add_product items, product, price, qty
        if is_product_in_cart? items, product
          change_qty items, product, qty
        else
          merge_cart_products(items, prepare_product_item(product, price, qty))
        end
      end


      def get_grand_total cart
        subtotal = cart.items.inject(0) {|sum, p|
          sum + BigDecimal.new(p[1]['subtotal'])
        }
        subtotal.round(@scale['total'])
      end

      def _delete_item items, product_sku
        items.delete(product_sku)
        items
      end

      def _count_items items
        items.values.map {|i| i['qty']}.inject {|sum, q| sum.to_i + q.to_i}
      end

      public

      def find_by_customer_id customer_id
        cart =TurboCassandra::Model::Cart.find customer_id
        cart.to_hash
      end

      def add_product customer_id, product, price, qty
        cart =TurboCassandra::Model::Cart.find customer_id
        if cart.nil?
          cart = create customer_id
        end
        items = _add_product(cart.items, product, price, qty)
        cart.update_attributes items: items
        cart.update_attributes subtotal: get_grand_total(cart)

      end

      def update cart
        cart = TurboCassandra::Model::Cart.new cart
        cart.subtotal = BigDecimal.new(cart.subtotal.to_s).round(@scale['subtotal'],BigDecimal::EXCEPTION_NaN)
        scale_subtotal(cart)
        cart.save
         _count_items(cart.items).to_s
      end

      def delete_product customer_id, product_sku
        cart =TurboCassandra::Model::Cart.find customer_id
        items = _delete_item cart.items, product_sku
        cart.update_attributes items: items
      end

      def empty_cart customer_id
        cart =TurboCassandra::Model::Cart.find customer_id
        cart.update_attributes items: {}, subtotal: BigDecimal.new(0)
        true
      end

      def count_products customer_id
        cart =TurboCassandra::Model::Cart.find customer_id
        items = cart.items
        unless items.nil? or items.first.nil?
          _count_items(items)
        end
      end


      def set_currency customer_id, currency
        cart =TurboCassandra::Model::Cart.find customer_id
        cart.update_attributes currency: currency
        true
      end

      def find customer_id
        cart =TurboCassandra::Model::Cart.find customer_id
        cart.to_hash
      end

      def all
        TurboCassandra::Model::Cart.all
      end
    end
  end
end