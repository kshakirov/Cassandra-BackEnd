module TurboCassandra
  class MenuBackEnd
    def initialize
      @attribute = Attribute.new
      @attribute_set = AttributeSet.new
      @currency = Currency.new
      @featured = FeaturedProduct.new
      @new = NewProduct.new
      @transformer = FeaturedTransformer.new
      @catalog_manager = CatalogManager.new
      @critical_catalog_manager = CriticalCatalogManager.new
    end
    private
    def normalize_list list
      list.each_with_index.map { |l, i| [l, i] }
    end

    def _get_manufacturers
      attr = @attribute.find 'manufacturer'
      options = attr.first['options']
      normalize_list(options)
    end


    def _get_parts
      attr = @attribute.find 'part'
      options = attr.first['options']
      normalize_list(options)
    end

    def _get_base_currency currencies
      base =currencies.select { |c| c['base'] }
      base.first['code']
    end

    def _get_rates currencies
      Hash[currencies.map { |sym| [sym['code'], sym['rate']] }]
    end

    def _get_critical_parts attrs, attr_sets
      critical_parts = attr_sets.select{|a| a['critical']}
      if critical_parts.size > 0
        attrs.select{|attr|
          critical_parts.select{|cp|attr[0] ==cp['name'] }.size > 0
        }
      end
    end

    public

    def get_parts
      _get_parts.to_json
    end

    def get_critical_parts
        _get_critical_parts( _get_parts, @attribute_set.find_all).to_json
    end

    def get_manufacturers
      [_get_manufacturers, _get_parts].to_json
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

    def get_headers part_type
      @catalog_manager.get_headers part_type
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