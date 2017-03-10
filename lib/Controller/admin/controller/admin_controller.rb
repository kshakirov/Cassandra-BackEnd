module TurboCassandra
  module Controller
    class Admin
      include TurboCassandra::AdminCustomerAddress
      include AdminCustomerPassword
      include AdminCustomerRespose
      private

      def get_customer_by_email email
        @customer.find_by_email email
      end

      def search_customer email
        get_customer_by_email(email)
      end

      def customer_available? customer
        not (customer.nil? or not customer)
      end

      def add_customer_info email
        {
            "email" => email,
            "group_id" => '2',
            "default_shipping_address" => add_default_shipping_address,
            "default_billing_address" => add_default_billing_address
        }
      end

      def create_base customer_data
        password = create_password(customer_data)
        customer_data['cid'] = @customer.new(customer_data)
        respond_with_customer(customer_data, password)
      end

      def _create_new_customer email
        customer_data = add_customer_info(email)
        create_base(customer_data)
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

      def create_new_customer_by_admin body
        customer_data = JSON.parse body
        customer_data["default_shipping_address"] = add_default_shipping_address
        customer_data["default_billing_address"] = add_default_billing_address
        create_base(customer_data)
      end

      def delete id
        @customer.delete(id)
      end
    end
  end
end