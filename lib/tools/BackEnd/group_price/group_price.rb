module TurboCassandra
  class GroupPriceBackEnd
    extend Forwardable
    def initialize
      @group_price = GroupPrice.new
    end

    def_delegator :@group_price, :find_by_sku_group_id, :get_price
  end
end