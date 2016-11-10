module TurboCassandra
  class MenuBackEnd
    def initialize
      @attribute = Attribute.new
      @currency = Currency.new
      @featured = FeaturedProduct.new
      @new = NewProduct.new
      @transformer = FeaturedTransformer.new
      @catalog_manager = CatalogManager.new
      @critical_catalog_manager = CriticalCatalogManager.new
    end

    def normalize_list list
      list.each_with_index.map { |l, i| [l, i] }
    end

    def _get_manufacturers
      attr = @attribute.find 'manufacturer'
      options = attr.first['options']
      normalize_list(options)
    end

    def get_manufacturers
      [_get_manufacturers, _get_parts].to_json
    end

    def _get_parts
      attr = @attribute.find 'part'
      options = attr.first['options']
      normalize_list(options)
    end

    def get_parts
      _get_parts.to_json
    end

    def get_critical_parts

    end

    def _get_base_currency currencies
      base =currencies.select { |c| c['base'] }
      base.first['code']
    end

    def _get_rates currencies
      Hash[currencies.map { |sym| [sym['code'], sym['rate']] }]
    end

    def create_currency_response currencies
      {
          base: _get_base_currency(currencies),
          date: "Wednesday 12th of October 2016 05:07:50 PM",
          rates: _get_rates(currencies)
      }
    end

    def get_currencies
      create_currency_response(@currency.all).to_json
    end

    def get_featured_product
      @transformer.get_featured_products(@featured.all).to_json
    end

    def get_new_product
      @transformer.get_featured_products(@new.all).to_json
    end

    def get_headers
      @catalog_manager.get_headers
    end

    def get_filters
      @catalog_manager.get_filters
    end

    def get_sorters
      @catalog_manager.get_sorters
    end

    def get_manufacturer_filters
      @catalog_manager.get_manufacturer_filters
    end

    def get_critical_headers part_type_id
        @critical_catalog_manager.get_headers(part_type_id).to_json
    end
    def get_critical_filters part_type_id
      @critical_catalog_manager.get_filters(part_type_id).to_json
    end
    def get_critical_sorters part_type_id
      @critical_catalog_manager.get_sorters(part_type_id).to_json
    end
  end
end