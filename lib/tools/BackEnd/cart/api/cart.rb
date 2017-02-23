module TurboCassandra
  module API
    class Cart
      extend Forwardable

      def initialize
        @cart_model = TurboCassandra::Model::Cart.new
      end

      def find customer_id
        @cart_model.find_by_customer_id(customer_id)
      end

      def_delegator :@cart_model, :add_product, :add_product
      def_delegator :@cart_model, :delete_product, :delete_product
      def_delegator :@cart_model, :purge, :empty_cart
      def_delegator :@cart_model, :count_items, :count_products
    end
  end
end