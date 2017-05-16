module TurboCassandra
  module Model

    class NewProduct < BaseModel
    end
    NewProduct.primary_index = ['sku']
    class NewProductOrder < BaseModel
    end
    NewProductOrder.primary_index = ['cluster','ord']
  end
end