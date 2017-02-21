module TurboCassandra
  module API
    class Customer
      def initialize
        @customer = TurboCassandra::Model::Customer.new
      end

      def find_by_customer_id id
        @customer.find(id)
      end

      def update customer_data
        @customer.update customer_data
      end


      def all
        @customer.find_all
      end

      def find_by_email email
        @customer.find_by_email(email)
      end

      def new hash
        @customer.new(hash)
      end

    end
  end
end