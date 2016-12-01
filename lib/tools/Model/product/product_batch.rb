module TurboCassandra
  class ProductBatch
    def remove_keys product_hash
      keys = %w( where_used service_kits bill_of_materials group_price action)
      keys.each { |k| product_hash.delete(k) }
    end

    def select_integers crit_dims
      crit_dims.select { |k, v| v['type']=='INTEGER' }
    end

    def select_enums crit_dims
      crit_dims.select { |k, v| v['type']=='ENUMERATION' }
    end

    def select_decimals crit_dims
      crit_dims.select { |k, v| v['type']=='DECIMAL' }
    end

    def to_map hash
      hash.update(hash) { |k, v| v['value'] }
    end

    def remove_null_values custom_attrs
      custom_attrs.select { |k, v| not v['value'].nil? }
    end

    def remove_product_null_values product_hash
      product_hash.select{|k,v| not v.nil?}
    end

    def _prepare_interchanges interchanges
      interchanges.split(',').map{|i| i.to_i}
    end

    def prepare_interchanges product_hash
        unless product_hash['interchanges'].nil?
          product_hash['interchanges'] = _prepare_interchanges(product_hash['interchanges'])
        end
    end

    def _parse_critical_attributes product_hash
      custom_attrs = remove_null_values(product_hash['custom_attrs'])
      product_hash['critical_decimal'] = to_map(select_decimals custom_attrs)
      product_hash['critical_enum'] = to_map(select_enums custom_attrs)
      product_hash['critical_integer'] = to_map(select_integers custom_attrs)
      product_hash.delete('custom_attrs')
    end

    def parse_critical_attributes product_hash
      if product_hash.key? 'custom_attrs'
        _parse_critical_attributes(product_hash)
      end
      remove_product_null_values product_hash
    end
  end
end