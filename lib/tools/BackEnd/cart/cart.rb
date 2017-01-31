module TurboCassandra
  class CartBackEnd
    extend Forwardable
    def initialize
      @group_price = Cart.new
    end
    def find customer_id
        @group_price.find_by_customer_id(customer_id).to_json
    end
    def_delegator :@group_price, :add_product, :add_item
    def_delegator :@group_price, :delete_product, :delete_item
  end
end