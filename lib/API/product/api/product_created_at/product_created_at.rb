module TurboCassandra
  module API
    class ProductCreatedAt
      def initialize

      end
      def create product_hash
        product_created_at = TurboCassandra::Model::ProductCreatedAt.new  product_hash
        product_created_at.save
      end

      def where manufactures, part_types, page_size=10, paging_state=nil
        params = {
            "manufacturer" => manufactures,
            "part_type" => part_types
        }
        paging_state = {
            "page_size" => page_size,
            "paging_state" => paging_state
        }
        TurboCassandra::Model::ProductCreatedAt.paginate paging_state, params
      end

      def delete manufacturer, part_type, created_at
        TurboCassandra::Model::ProductCreatedAt.delete manufacturer, part_type, created_at
      end
    end
  end
end