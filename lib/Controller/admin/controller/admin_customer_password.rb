module TurboCassandra
  module Controller
    module AdminCustomerPassword
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

      def _reset_password email
        customer = search_customer(email)
        if customer_available?(customer)
          respond_with_password(customer)
        else
          respond_with_not_found
        end
      end

    end
  end
end