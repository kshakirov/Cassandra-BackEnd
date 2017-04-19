module TurboCassandra
  module OeRefUrl
    private
    def _each_interchange interchange
      {
          part_number: interchange['part_number'],
          part_number_clean: normalize_part_number(interchange['part_number']),
          product_url: '',
          manufacturer: interchange['manufacturer'],
          sku: interchange['id']
      }
    end


    def _get_ti_oe_ref_url product
      interchanges = query_interchange_service product
      unless interchanges.nil?
        interchanges.compact.map { |i| _each_interchange(i) }
      end
    end


    def get_if_not_external interchanges
      unless interchanges.nil? and interchanges.class.name == 'Array'
        parts = interchanges.select { |interchange| is_not_external_manufacturer?(interchange) }
        unless parts.nil?
          parts.map { |p| normalize_part_number(p[:part_number] )}
        end
      end
    end

    def get_if_external interchanges
      external_interchanges =
          interchanges.select { |i|  (not is_not_external_manufacturer?(i)) }
      external_interchanges.map{|i |
        i.delete(:manufacturer)
        i
      }
    end


    def get_ti_oe_ref_url product
      interchanges = _get_ti_oe_ref_url(product)
      unless interchanges.nil?
        return get_if_external(interchanges) , get_if_not_external(interchanges)
      end
    end

    def get_not_ti_oe_ref_url product
      [{
           part_number: product['part_number'],
           part_number_clean: normalize_part_number(product['part_number']),
           product_url: '',
           sku: product['sku']
       }]
    end

    public
    def get_oe_ref_url product
      if is_ti_manufactured? product
        get_ti_oe_ref_url(product)
      else
        get_not_ti_oe_ref_url(product)
      end
    end
  end
end