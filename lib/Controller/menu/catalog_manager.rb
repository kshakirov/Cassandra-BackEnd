module TurboCassandra
  module Controller
    module Menu
      class CatalogManager
        include TurboCassandra::Controller::Menu::CatalogHeader

        def initialize
          @attribute = TurboCassandra::API::Attribute.new
          @headers = initialize_headers
          @sorters = initialize_sorters
          @filters = initialize_filters
        end

        private

        def get_manufacturers
          manr = @attribute.find 'manufacturer'
          manr.first['options']
        end

        def get_part_types
          part = @attribute.find 'part'
          part.first['options']
        end

        def get_turbo_type
          turbo_types = @attribute.find 'turbo_type'
          turbo_types.first['options']
        end

        def build_manufacturer_filter_item manufacturer, id
          {
              "name": manufacturer,
              "option_id": id,
              "code": "manufacturer"
          }
        end

        def build_part_type_filter_item part_type, id
          {
              "name": part_type,
              "option_id": id,
              "code": "part_type"
          }
        end

        def build_turbo_type_filter_item turbo_type, id
          {
              "name": turbo_type,
              "option_id": id,
              "code": "turbo_type"
          }
        end

        def build_manufacturer_filter
          manfrs = get_manufacturers
          manfrs.each_index.map { |i| build_manufacturer_filter_item(manfrs[i], i) }
        end

        def build_part_type_filter
          parts = get_part_types
          parts.each_index.map { |i| build_part_type_filter_item(parts[i], i) }
        end

        def build_turbo_type_filter
          turbo_types = get_turbo_type
          turbo_types.each_index.map { |i| build_turbo_type_filter_item(turbo_types[i], i) }
        end

        public
        def get_headers part_type
          #TODO hardcoded turbo part tipe id needs correct way
          unless part_type=='catalog' or part_type == "1"
            last = @headers.size - 3
            return @headers[0.. last]
          end
          @headers
        end

        def get_filters
          unless @filters.class.name == 'Array' or @filters.size != 3
            @filters = initialize_filters
          end
          @filters[0][:options] = build_turbo_type_filter
          @filters[1][:options] = build_manufacturer_filter
          @filters[2][:options] = build_part_type_filter
          @filters
        end

        def get_part_type_filters
          @filters[0][:options] = build_turbo_type_filter
          @filters[1][:options] = build_manufacturer_filter
          [@filters[0], @filters[1]]
        end

        def get_sorters
          @sorters
        end

        def get_manufacturer_filters
          @filters[0][:options] = build_turbo_type_filter
          [@filters[0]]
        end

      end
    end
  end
end