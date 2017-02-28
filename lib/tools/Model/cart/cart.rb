module TurboCassandra
  module Model
    class Cart
      public
      def initialize
      end

      private
      def create_insert_cql
        "INSERT  INTO  carts  (id,currency,customer_id) VALUES (?,?,?)"
      end


      def create customer_id
        execute(create_insert_cql, [customer_id, 1, customer_id])
      end


      def create_select_where_id_cql
        "SELECT  * FROM carts  WHERE id=?"
      end

      def select_items_where_id_cql
        "SELECT  items FROM carts  WHERE id=?"
      end

      def create_update_product_item_sql
        "UPDATE carts SET items = ? WHERE id=?"
      end

      def create_update_total_sql
        "UPDATE carts SET subtotal = ? WHERE id=?"
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
        item_content['subtotal'] =(price * qty).to_s
        item_hash
      end


      def merge_cart_products cart, product_hash
        items = cart['items']
        if cart['items'].nil?
          items = {}
        end
        sku = product_hash.keys.first
        items[sku] = product_hash[sku]
        items
      end

      def _add_product cart, product, price, qty
        cql = create_update_product_item_sql
        args = merge_cart_products(cart, prepare_product_item(product, price, qty))
        execute(cql, [args, cart['id']])
      end

      def get_grand_total cart
        cart['items'].inject(0) { |sum, p|
          sum + p[1]['subtotal'].to_f
        }
      end

      def update_grand_total result, cart
        if result
          updated_cart = find_by_customer_id(cart['id'])
          grand_total = get_grand_total(updated_cart)
          execute(create_update_total_sql, [grand_total.to_f, updated_cart['id']])
        end
      end

      def _delete_item cart, product_sku
        cart['items'].delete(product_sku)
        cql = create_update_product_item_sql
        execute(cql, [cart['items'], cart['id']])
      end

      def _count_items items
        items.values.map{|i| i['qty']}.inject{|sum,q| sum.to_i + q.to_i}
      end

      public

      def find_by_customer_id customer_id
        cart = execute(create_select_where_id_cql, [customer_id])
        cart.first
      end

      def add_product customer_id, product, price, qty
        cart = find_by_customer_id(customer_id)
        if cart.nil?
          create customer_id
          cart = find_by_customer_id(customer_id)
        end
        update_grand_total(_add_product(cart, product, price, qty), cart)

      end

      def delete_product customer_id, product_sku
        cart = find_by_customer_id(customer_id)
        update_grand_total(_delete_item(cart, product_sku), cart)
      end

      def execute cql, args
        session = TurboCluster.get_session
        statement = session.prepare(cql)
        session.execute(statement, arguments: args, consistency: :one)
      end

      def purge customer_id
        cart = find_by_customer_id(customer_id)
        execute(create_update_product_item_sql, [{}, cart['id']])
      end

      def count_items customer_id
        items = execute(select_items_where_id_cql, [customer_id])
        unless items.nil? or items.first.nil?
          _count_items(items.first['items'])
        end
      end

    end
  end
end