module TurboCassandra
  class AttributeSetBackEnd
    public
    def initialize
      @attribute_set = AttributeSet.new
    end
    private
    public
    def get_attribute_sets_list
      @attribute_set.find_all.to_json
    end

    def get_attribute_set name, value
      @attribute_set.find_by(name, value
      ).to_json
    end

    def update_critical_property set
      @attribute_set.update('critical', set['critical'])
    end
  end
end