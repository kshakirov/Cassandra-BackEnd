module TurboCassandra
  module Controller
    class Admin
      private

      def get_customer_by_email email
        @customer.find_by_email email
      end

      def create_password customer
        new_password = SecureRandom.urlsafe_base64(10)
        customer['password']= @login_manager.hash_password(new_password)
        new_password
      end

      def respond_with_password customer
        new_password = create_password(customer)
        @customer.update(customer)
        {
            "result": true,
            "password": new_password
        }
      end

      def respond_with_not_found
        {
            "result": false
        }
      end

      def search_customer email
        get_customer_by_email(email)
      end

      def customer_available? customer
        not (customer.nil? or not customer)
      end

      def _reset_password email
        customer = search_customer(email)
        if customer_available?(customer)
          respond_with_password(customer)
        else
          respond_with_not_found
        end
      end

      def respond_with_customer customer_hash, password
        customer_hash["result"] = true
        customer_hash["password"] = password
        customer_hash.delete "id"
        customer_hash
      end

      def _create_new_customer email
        customer_hash = {"email" => email}
        password = create_password(customer_hash)
        @customer.new(customer_hash)
        respond_with_customer(customer_hash, password)
      end

      public
      def initialize
        @customer = TurboCassandra::API::Customer.new
        @cart = Cart.new
        @login_manager = Login.new
      end

      def reset_password email
        _reset_password email
      end

      def create_new_customer email
        _create_new_customer email
      end
    end
  end
end