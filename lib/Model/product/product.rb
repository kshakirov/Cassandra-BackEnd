module TurboCassandra
  module Model

    class Product < BaseModel

    end
    Product.primary_index = ['sku']
  end
end