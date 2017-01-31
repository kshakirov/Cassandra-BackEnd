module TurboCassandra
  class ProductBackEnd
    public
    def initialize
      @product = Product.new
      @attribute = Attribute.new
    end

    private
    def get_set_attributes product
      attrs = @attribute.find_by_set_name(product['part_type'])
      Hash[attrs.map { |a| [a['code'], a] }]
    end

    def build_tolerance tolerance_attribute, tolerance_value
      {
          "inches": tolerance_value[0],
          "scale": tolerance_attribute['scale'],
          "centimeters": tolerance_value[0] * 25.4
      }
    end

    def get_tolerance key_value, attrs, product_critical
      tolerance_attribute = attrs.values.select { |a| a['parent_id'] == key_value }
      unless tolerance_attribute.nil? or tolerance_attribute.empty?
        tolerance_value = product_critical.select { |pc| pc ==key_value }
        build_tolerance tolerance_attribute.first, tolerance_value.values
      end
    end

    def is_applicable? value
      if value && value >=0
        return true
      elsif value.nil?
        return true
      end
      false
    end

    def create_critical_item attr, value
      {
          "label": attr['label'],
          "value": {
              "inches": value,
              "centimeters": value.to_f * 25.4
          },
          "critical": true,
          "decimal": true,
          "scale": attr['scale'],
          "unit": attr['unit'],
          "applicable": is_applicable?(value),
          "tolerance": 0
      }
    end



    def add_critical_attributes product
      attrs = get_set_attributes(product)
      attrs.keys.map { |key|
        if product['critical_decimal'].has_key? key
          p = create_critical_item(attrs[key], product['critical_decimal'][key])
          p['tolerance'] = get_tolerance(key, attrs, product['critical_decimal'])
          p
        else
          create_critical_item(attrs[key], nil)
        end
      }
    end

    def _get_product sku
      sku = sku.to_i
      product = @product.find([sku]).first
      if product.key? 'critical_decimal' and not product['critical_decimal'].nil?
        product['critical'] = add_critical_attributes(product)
      end
      product
    end

    def _get_products skus
      skus = skus.map{|sku| sku.to_i}
      products = @product.where skus
      products.map { |p|
        if p.key? 'critical_decimal' and not p['critical_decimal'].nil?
          p['critical'] = add_critical_attributes(p)
        end
        p
      }
    end

    public
    def get_product sku
      _get_product(sku).to_json
    end

    def get_products skus
      _get_products(skus)
    end
  end
end