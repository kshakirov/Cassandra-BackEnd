module TurboCassandra
  module Controller
    class AttributeSet
      def initialize
        @attribute_set = TurboCassandra::API::AttributeSet.new
        @attribute_api = TurboCassandra::API::Attribute.new
      end

      def get_attribute_sets_list
        @attribute_set.find_all
      end

      def get_attribute_set name, value
        attribute_set = @attribute_set.find_by(name, value)
        attribute_set.first
      end

      def update_critical_property set
        @attribute_set.update('critical', set['critical'], set['code'])
      end
    end
  end
end