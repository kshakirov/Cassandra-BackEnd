module TurboCassandra
  class GroupPriceBackEnd
    extend Forwardable
    def initialize
      @cart = GroupPrice.new
    end

    def_delegator :@cart, :find_by_sku_group_id, :get_price
  end
end