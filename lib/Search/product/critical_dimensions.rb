module TurboCassandra
  class CriticalDimension
    public
    def initialize
      attribute = TurboCassandra::API::Attribute.new
      @attributes = attribute.all
    end

    private

    def is_applicable? k
      if k[:value][:inches] < 0
        k[:value][:inches] = nil
        k[:value][:centimeters] = nil;
        return false
      end
      true
    end

    def get_attribute code
      attr = @attributes.select { |a| a['code'] == code }
      attr.first
    end

    def get_tolerance_attribute code
      tolerance = @attributes.select { |a| a['parent_id'] == code }
      if tolerance and tolerance.size > 0
        v = tolerance.first['tolerance']  * (10  ** (-1 * tolerance.first['scale']))
        {
            inches: v.to_f,
            centimeters: v.to_f * 2.54,
            scale: tolerance.first['scale']
        }
      end
    end


    def prepare_decimal_attributes product

      product.keys.map { |k|
        value = {
            k => {
                value: {
                    inches: product[k],
                    centimeters: product[k] * 2.54
                },
                scale: get_attribute(k)['scale'],
                units: get_attribute(k)['unit'],
                tolerance: get_tolerance_attribute(k),
                applicable: true
            }
        }
        value[k][:applicable] = is_applicable?(value[k])
        value
      }
    end

    def array_to_hash array
      Hash[array.map { |a| [a.keys.first, a.values.first] }]
    end

    public
    def get_critical_dimensions product
      if product.key? 'critical_decimal' and not product['critical_decimal'].nil?
        array_to_hash(prepare_decimal_attributes(product['critical_decimal']))
      end
    end
  end
end