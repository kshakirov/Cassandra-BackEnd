module TurboCassandra
  module Controller
    module AlsoBought

      def find_bundled_products product_sets, sku
        product_sets.select  do  |s|
            if not s.nil?
            matches = s.select{|p| p['sku'] == sku}
            not matches.empty?
            else
              false
            end
        end
      end

      def find_all_products orders
        orders.map { |o| o['products'] }
      end

      def add_key_or_value matched_hash , sku, name
        if matched_hash.key? sku
          matched_hash[sku]['value'] += 1
        else
          matched_hash[sku] = {'value' => 1, 'name' => name  }
        end
      end

      def create_matched_hash matched_sets
          matched_hash = {}
          matched_sets.each do |set|
              set.each do |product|
                  add_key_or_value(matched_hash, product['sku'], product['name'])
              end
          end
        matched_hash
      end

      def delete_current_sku  matched_hash, sku
        matched_hash.delete sku
      end

      def rank_matched_hash matched_hash, sku
          delete_current_sku(matched_hash, sku)
          matched_hash.sort_by { |key,val| val['value']}.reverse
      end

      def _execute sku
        product_sets = find_all_products(@order.all)
        matched_sets = find_bundled_products(product_sets, sku)
        matched_hash = create_matched_hash(matched_sets)
        rank_matched_hash(matched_hash, sku)
      end

      def get_also_bought_products sku
        _execute(sku)
      end
    end
  end
end