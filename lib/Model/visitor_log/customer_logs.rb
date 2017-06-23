module TurboCassandra
  module Model
    class CustomerLog < BaseModel
    end
    CustomerLog.primary_index = %W(customer_id date id ip)
  end
end