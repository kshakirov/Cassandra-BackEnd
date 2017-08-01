module TurboCassandra
  module Model

    class Cart < BaseModel
    end

    Cart.primary_index = "id"


  end
end