module TurboCassandra
  class OeRefUrl
    public
    def initialize
      @product = Product.new
    end

    private
    def _each_interchange sku
        p = @product.find sku
        unless p.first.nil?
          p = p.first
          {
              part_number: p['part_number'],
              part_number_clean: TurboCassandra::normalize_part_number(p['part_number']),
              product_url: '',
              sku: p['sku']
          }
        end
    end

    def   _get_ti_oe_ref_url product
      unless product['interchanges'].nil?
        product['interchanges'].map{|i| _each_interchange(i)}
      end
    end
    def _get_not_ti_oe_ref_url product
      [{
           part_number: product['part_number'],
          part_number_clean:  TurboCassandra::normalize_part_number(product['part_number']),
          product_url: '',
          sku: product['sku']
      }]
    end

    public
    def get_oe_ref_url product
      if TurboCassandra::is_ti_manufactured? product
        _get_ti_oe_ref_url (product)
      else
        _get_not_ti_oe_ref_url(product)
      end
    end
  end
end