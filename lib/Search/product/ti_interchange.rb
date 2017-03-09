module TurboCassandra
  class TiInterchange
    public
    def initialize
      @product = TurboCassandra::API::Product.new
    end

    private

    def prepare_response product
      {
          ti_part: product['sku'],
          ti_sku: product['sku'],
          ti_url: "/#/part/sku",
          ti_part_number: product['part_number'],
          ti_part_number_clean: product['part_number'].gsub('-','').downcase
      }
    end

    def is_ti_manufactured product
      unless product .first.nil?
          product.first['manufacturer']=='Turbo International'
      end
    end

    def _get_ti_interchange intgerchanges
      response  = nil
      intgerchanges.select do |sku|
       product = @product.find_by_sku  sku
       if is_ti_manufactured(product)
          response = prepare_response(product.first)
       end
      end
      response
    end

    public

    def get_ti_interchange interchanges
      unless interchanges.nil?
      _get_ti_interchange interchanges
      end
    end

    def get_ti_itself product
       prepare_response product
    end
  end
end