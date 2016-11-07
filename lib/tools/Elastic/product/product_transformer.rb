module TurboCassandra
  class EsProductTransformer
    def initialize
      @ti_part_manager = TiInterchange.new
      @oe_ref_url_manager = TurboCassandra::OeRefUrl.new
      @criticas_manager = TurboCassandra::CriticalDimension.new
      @manufacturer_manager = TurboCassandra::Manufacturer.new
      @part_type_manager = TurboCassandra::PartType.new
      @visibility_manager = TurboCassandra::Visibility.new
    end

    def _create_turbo_model product
      [{
          code: 1, name: product['turbo_model']
      }]
    end

    def _create_turbo_type product
      [{
          code: 1, name: product['turbo_type']
      }]
    end

    def is_ti_manufacturer? product
        product['manufacturer'] == 'Turbo International'
    end

    def _create_scheleton product
      {
          description: product['description'],
          name: product['name'],
          part_number: {name: product['part_number']},
          sku: product['sku'],
          turbo_model: _create_turbo_model(product),
          turbo_type: _create_turbo_type(product)
      }
    end

    def _set_catalog_visibility scheleton,  product
      scheleton["visible_in_catalog"] = @visibility_manager.get_visibility(product)
    end

    def add_ti_part scheleton , product
      if not is_ti_manufacturer? product
        scheleton[:ti_part] = @ti_part_manager.get_ti_interchange(product['interchanges'])
      else
        scheleton[:ti_part] = @ti_part_manager.get_ti_itself(product)
      end
    end

    def add_oe_ref_url scheleton, product
      scheleton["oe_ref_urls"] = @oe_ref_url_manager.get_oe_ref_url(product)
    end

    def add_critical_attributes scheleton,  product
        criticals = @criticas_manager.get_critical_dimensions product
        unless criticals.nil?
          scheleton.merge!(criticals)
        end
    end

    def add_manufacturer scheleton,  product
      scheleton["manufacturer"] = @manufacturer_manager.get_manufacturer(product)
    end

    def add_part_type scheleton,  product
      scheleton["part_type"] = @part_type_manager.get_part_type(product)
    end

    def run product
      scheleton = _create_scheleton product
      add_ti_part(scheleton, product)
      add_oe_ref_url(scheleton, product)
      add_critical_attributes(scheleton, product)
      add_manufacturer(scheleton, product)
      add_part_type(scheleton, product)
      _set_catalog_visibility(scheleton, product)
      scheleton
    end
  end
end