module TurboCassandra
  module API
    class ComparedProducts
      extend Forwardable
      def_delegator :@compared_products_model, :insert, :update
      def_delegator :@compared_products_model, :delete, :delete
      def_delegator :@compared_products_model, :find, :find

      def initialize
        @compared_products_model = TurboCassandra::Model::ComparedProducts.new
      end


    end
  end
end