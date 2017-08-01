module TurboCassandra
  module Model
    class ProductCreatedAt < BaseModel

    end
    ProductCreatedAt.table_name = "products_created_at"
    ProductCreatedAt.primary_index = ['manufacturer','part_type','created_at']
  end
end