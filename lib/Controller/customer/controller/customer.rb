module TurboCassandra
  module Controller

    module AddressVerification

      def is_usa? address
        address['country_id']=="US"
      end

      def has_country? address
        not address['country_id'].nil? and not address['country_id'].size ==0
      end

      def has_not_state? address
        address['region_id'].nil? or address['region_id'].size == 0
      end

      def no_city_street_pcode address
        keys = %W(city street postcode)
        keys.any? do |key|
          address[key].nil? or address[key].size == 0
        end
      end

      def verify_address data
        address_type = get_address_name(data)
        if not has_country? data[address_type]
          raise "Country Is Required"
        elsif is_usa? data[address_type] and has_not_state? data[address_type]
          raise "State/Province Is Required"
        elsif no_city_street_pcode data[address_type]
          raise "City,Street, Postal Code  are Required"
        end
        true
      end
    end



    class Customer
      include AddressVerification
      private
      def get_customer_id customer_data
        if customer_data.class.name =='Array'
          customer_data.first['id']
        elsif customer_data.class.name.include? 'Hash'
          customer_data['id'].to_i
        end
      end

      def is_email_unique? data
        customers = TurboCassandra::Model::Customer.find_by email: data['email']
        if customers.empty? or customers.first['id'] == data['id']
          true
        else
          raise 'Email Is Already Used'
        end
      end

      def get_address_name data
        data.keys.find { |key| key.include? 'address' }
      end


      public
      def initialize
        @customer = TurboCassandra::API::Customer.new
        @cart = TurboCassandra::API::Cart.new
        @login_manager = Login.new
      end

      def get_account customer_data
        id = get_customer_id(customer_data)
        customer = @customer.find_by_customer_id id
        customer.to_hash
      end

      def get_account_by_email params
        email = params['email']
        customer = @customer.find_by_email email
         raise "No Customer With Email #{email}" if customer.nil?
        customer.to_hash
      end



      def update_account data
        if is_email_unique? data
          @customer.update(data)
        end
      end

      def update_address body
        data = JSON.parse body
        customer = @customer.find_by_customer_id data['id']
        if not customer.nil? and verify_address(data)
          method_name = get_address_name(data)
          customer.send(method_name, data[method_name])
          customer.save
        end
      end

      def update_password data
        validated = @login_manager.validate_customer(data['password'], data['email'])
        if validated
          data['password'] = @login_manager.hash_password(data['password_new'])
          data.delete 'password_new'
          update_account(data)
        end
        validated
      end

      def get_customer_data customer
        {
            name: get_name(customer),
            cart: get_cart_items_number(customer),
            wishlist: 3
        }
      end

      def get_all
        @customer.all
      end

      def get_by_email email
        @customer.find_by_email(email)
      end

      private

      def get_name customer
        customer['name']
      end

      def get_cart_items_number customer
        cart = @cart.find(customer['id'])
        unless cart.nil? or cart['items'].nil?
          cart['items'].keys.size
        end
      end

      def create customer_data
        @customer.insert(customer_data)
      end
    end
  end
end