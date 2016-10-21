module TurboCassandra
  class OrderBackEnd
    def initialize
      @order = Order.new
    end
    def get_order_by_customer_id id
        _get_order(id).to_json
    end
    private

    def _get_order id
      order = @order.find_by_customer_id(id)
      order.map{|o| o}
    end
  end
end