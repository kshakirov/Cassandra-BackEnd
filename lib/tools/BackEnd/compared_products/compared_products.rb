module TurboCassandra
  class ComparedProductsBackEnd
    extend Forwardable
    def_delegator :@group_price_backend, :get_price, :get_price
    def initialize
      @compared_products = ComparedProducts.new
      @product_backend = TurboCassandra::ProductBackEnd.new
      @group_price_backend = TurboCassandra::GroupPriceBackEnd.new
    end
    private

    def prepare_criticals product
        product['critical_decimal']
    end

    def _update hash
       hash['date'] = Time.now.to_time
      @compared_products.insert(hash)
    end
    def _find_by_customer customer_id, customer_group
      skus = @compared_products.find(customer_id)
        unless skus.nil?
          @product_backend.get_products(skus).map{|p| {
              sku: p['sku'],
              part_number:  p['part_number'],
              part_type: p['part_type'],
              description: p['description'],
              prices:  get_price(p['sku'], customer_group),
              critical: prepare_criticals(p)
          }
          }.to_json
        end
    end

    def _delete customer_id, product
      @compared_products.delete(customer_id, product)
    end


    public
    def find_by_customer customer_id, customer_group
      _find_by_customer(customer_id, customer_group)
    end

    def update hash
      _update(hash)
    end

    def delete customer_id, product
      _delete(customer_id, product)
    end
  end
end