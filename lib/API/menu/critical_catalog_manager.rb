module TurboCassandra
  class CriticalCatalogManager
    private
    def get_part_types
      attr = @attribute.find 'part'
      options = attr.first['options']
      create_part_type_hash(options)
    end

    def normalize_list list
      list.each_with_index.map { |l, i| [i, l] }
    end

    def create_part_type_hash options
      Hash[normalize_list(options)]
    end

    def get_attributes_by_part_name name
      get_parent_attributes(@attribute.find_by_set_name(name))
    end

    def get_tolerance_attrbutes  attrs
      attrs.select{|a| not a['parent_id'].nil?}
    end
    def get_parent_attributes attrs
      attrs.select{|a|  a['parent_id'].nil? and a['type']=='decimal'}
    end


    def sub_decimal_4_price type
      type == 'decimal' ? 'price' : type
    end

    def create_response attrs
      attrs.map{|a|
          {
            code:  a['code'],
            type: sub_decimal_4_price(a['type']),
            name: a['label'],
            scale: a['scale'],
            units: a['unit'],
            seq_num:  a['seq_num']
          }
      }.sort{|a,b| a[:seq_num] <=> b[:seq_num]}
    end

    public
    def initialize
      @headers = TurboCassandra::initialize_critical_headers
      @sorters = TurboCassandra::initialize_critical_sorters
      @filters = TurboCassandra::initialize_filters
      @attribute = TurboCassandra::API::Attribute.new
      @part_types = get_part_types
    end


    def get_headers part_type_id
      part_type_name = @part_types[part_type_id.to_i]
      attrs = get_attributes_by_part_name(part_type_name)
      @headers +  create_response(attrs)
    end

    def get_filters part_type_id
      part_type_name = @part_types[part_type_id.to_i]
      attrs = get_attributes_by_part_name(part_type_name)
      create_response(attrs)
    end

    def get_sorters part_type_id
      part_type_name = @part_types[part_type_id.to_i]
      attrs = get_attributes_by_part_name(part_type_name)
      @sorters  +  create_response(attrs)
    end


  end
end