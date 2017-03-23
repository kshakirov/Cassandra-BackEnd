module TurboCassandra
  module API
    class ProductCreatedAt
      def initialize
        @product_created_at_model = TurboCassandra::Model::ProductCreatedAt.new
      end
      def create product_hash
        @product_created_at_model.insert product_hash
      end

      def where manufactures, part_types, page_size=10, paging_state=nil
        @product_created_at_model.paginate(manufactures, part_types, page_size, paging_state)
      end

      def delete manufacturer, part_type, created_at
        @product_created_at_model.delete manufacturer, part_type, created_at
      end
    end
  end
end