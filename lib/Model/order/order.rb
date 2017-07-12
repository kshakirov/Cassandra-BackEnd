module TurboCassandra
  module Model
    class Order < BaseModel
    end
    Order.primary_index = 'order_id'
  end
end