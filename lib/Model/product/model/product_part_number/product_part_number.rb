module TurboCassandra
  module Model
    class ProductPartNumber < BaseModel

    end
    ProductPartNumber.primary_index = 'part_number'
  end
end