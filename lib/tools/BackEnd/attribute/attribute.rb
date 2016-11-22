module TurboCassandra
  class AttributeBackEnd
    public
    def initialize
      @attribute = Attribute.new
    end
    private
    public
    def get_attributes_list
        @attribute.find_all.to_json
    end
  end
  end