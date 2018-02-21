module TurboCassandra
  module PartType
    private
    def get_part_type_code part_type
      @part_types.each_index.select{|i| @part_types[i] ==part_type}.first
    end
    def _get_part_type product
          get_part_type_code(product['part_type'])
    end
    public
    def get_part_type product
      _get_part_type product
    end

    def get_part_type_name product
        product['part_type']
    end
  end
end