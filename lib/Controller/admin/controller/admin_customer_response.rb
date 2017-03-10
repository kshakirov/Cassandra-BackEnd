module TurboCassandra
  module Controller
    module AdminCustomerRespose
      def respond_with_not_found
        {
            "result": false
        }
      end

      def respond_with_customer customer_hash, password
        customer_hash["result"] = true
        customer_hash["password"] = password
        customer_hash.delete "id"
        customer_hash
      end
    end
  end
end