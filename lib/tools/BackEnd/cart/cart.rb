module TurboCassandra
  class CartBackEnd
    extend Forwardable
    def initialize
      @cart = Cart.new
    end
    def find customer_id
        @cart.find_by_customer_id(customer_id).to_json
    end
    def_delegator :@cart, :add_product, :add_item
    def_delegator :@cart, :delete_product, :delete_item
  end
end