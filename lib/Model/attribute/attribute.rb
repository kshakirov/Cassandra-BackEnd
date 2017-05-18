module TurboCassandra
  module Model
    class Attribute < BaseModel
    end
    Attribute.primary_index  = ['code']
  end
end