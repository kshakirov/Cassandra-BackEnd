module TurboCassandra
  module API
    class GroupPrice
      extend Forwardable
      def find_by_sku_group_id sku, group_id
        group_prices = find sku
        unless group_prices.nil?
          group_prices.to_hash
          group_prices['prices'][group_id]
        end
      end

      def find sku
        group_prices = TurboCassandra::Model::GroupPrice.find sku
        unless group_prices.nil?
          group_prices.to_hash
        end
      end

      def create hash
        group_prices = TurboCassandra::Model::GroupPrice.new hash
        group_prices.save
      end

      def update_attributes sku, hashes
        group_prices = TurboCassandra::Model::GroupPrice.find sku
        group_prices.update_attributes hashes
      end

      def all
        TurboCassandra::Model::GroupPrice.all
      end

    end
  end
end