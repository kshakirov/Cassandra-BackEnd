module TurboCassandra
  class Manufacturer
    public
    def initialize
      attribute = TurboCassandra::API::Attribute.new
      @part_types = attribute.find('manufacturer').first['options']
    end
    private
    def get_manufacturer_code manufacturer
      @part_types.each_index.select{|i| @part_types[i] ==manufacturer}.first
    end
    def _get_manufacturer product
      [{
          code: get_manufacturer_code(product['manufacturer']),
          name: product['manufacturer']
      }]
    end
    public
    def get_manufacturer product
        _get_manufacturer product
    end
  end
end