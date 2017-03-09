module TurboCassandra
  module API
    class AttributeSet
      public
      def initialize
        @attribute_set = TurboCassandra::Model::AttributeSet.new
      end

      public
      def find_all
        @attribute_set.find_all
      end

      def find_by name, value
        @attribute_set.find_by(name, value)
      end

      def update name, value, code
        @attribute_set.update('critical', set['critical'], set['code'])
      end
    end
  end
end