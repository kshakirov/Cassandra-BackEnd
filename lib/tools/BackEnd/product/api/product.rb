module TurboCassandra
  module API
    class Product
        def initialize
          @product_model = TurboCassandra::Model::Product.new
        end
        def find_by_sku sku
          @product_model.find [sku]
        end
        def where_skus skus
          @product_model.where skus
        end
        def each &block
          @product_model.each &block
        end

    end
  end
end