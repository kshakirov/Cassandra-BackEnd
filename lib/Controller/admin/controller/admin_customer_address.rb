module TurboCassandra
  module AdminCustomerAddress
    def add_address
      {
          "city" => "",
          "company" => "",
          "country_id" => "",
          "postcode" => "",
          "region_id" => "",
          "street" => "",
          "telephone" => ""
      }
    end

    def add_default_billing_address
      add_address
    end

    def add_default_shipping_address
      add_address
    end
  end
end