module TurboCassandra
  module Model

    class FeaturedProduct < BaseModel
    end
    FeaturedProduct.primary_index = ['sku']
    class FeaturedProductOrder < BaseModel
    end
    FeaturedProductOrder.primary_index = ['cluster','ord']
  end
end