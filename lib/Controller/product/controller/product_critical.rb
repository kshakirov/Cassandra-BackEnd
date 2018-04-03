module TurboCassandra
  module Controller
    module CriticalDims
      def get_set_attributes product
        attrs = @attribute.find_by_set_name(product['part_type'])
        Hash[attrs.map {|a| [a['code'], a]}]
      end

      def build_tolerance tolerance_attribute, tolerance_value
        unless tolerance_value.empty?
          {
              "inches": tolerance_value[0],
              "scale": tolerance_attribute['scale'],
              "centimeters": tolerance_value[0] * 25.4
          }
        end
      end

      def get_tolerance key_value, attrs, product_critical
        tolerance_attribute = attrs.values.find {|a| a['parent_id'] == key_value}
        unless tolerance_attribute.nil? or tolerance_attribute.empty?
          tolerance_value = product_critical.select {|pc| pc ==tolerance_attribute['code']}
          build_tolerance tolerance_attribute, tolerance_value.values
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

      def is_tolerance? attr
        attr['parent_id'].nil? ? false : true

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
            "tolerance": 0,
            "is_tolerance": is_tolerance?(attr),
            "seq_num": attr['seq_num']
        }
      end


      def is_applicable_non_dec value
        unless value.nil?
          if value.class.name =="String" and value == "-99"
            return false
          else
            return true
          end
        end
        false
      end

      def create_critical_item_non_dec attr, value
        {
            "label": attr['label'],
            "value": value,
            "critical": true,
            "decimal": false,
            "applicable": is_applicable_non_dec(value),
            "unit": attr['unit'],
            "is_tolerance": is_tolerance?(attr),
            "seq_num": attr['seq_num']
        }
      end


      def get_non_critical_value key, product
        if not product['critical_enum'].nil? and
            product['critical_enum'].key? key
          product['critical_enum'][key]
        elsif not product['critical_integer'].nil? and
            product['critical_integer'].key? key
          product['critical_integer'][key]
        end
      end


      def add_critical_attributes product
        attrs = get_set_attributes(product)
        crit_attrs = attrs.keys.map {|key|
          if product['critical_decimal'].has_key? key
            p = create_critical_item(attrs[key], product['critical_decimal'][key])
            p[:tolerance] = get_tolerance(key, attrs, product['critical_decimal'])
            p
          else
            create_critical_item_non_dec(attrs[key], get_non_critical_value(key, product))
          end
        }
        crit_attrs = crit_attrs.select {|a| not a[:is_tolerance]}
        crit_attrs.sort_by {|a| a[:seq_num]}
      end

    end
  end
end