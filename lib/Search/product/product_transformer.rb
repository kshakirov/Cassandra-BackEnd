module TurboCassandra
  class EsProductTransformer
    attr_accessor :product_api, :tcas_server, :part_types, :manufacturer_types
    include TurboCassandra::TurboTools
    include TurboCassandra::Visibility
    include TurboCassandra::OeRefUrl
    include TurboCassandra::TcasService
    include TurboCassandra::TiChraManager
    include TurboCassandra::TiInterchange
    include TurboCassandra::Manufacturer
    include TurboCassandra::NotExternalManufacturer
    include TurboCassandra::PartType
    include TurboCassandra::ApplicationManager


    def init_enums
      attribute_api = TurboCassandra::API::Attribute.new
      @manufacturer_types = attribute_api.find('manufacturer').first['options']
      @part_types = attribute_api.find('part').first['options']
    end

    def initialize
      @product_api = TurboCassandra::API::Product.new
       init_enums
      @criticas_manager = TurboCassandra::CriticalDimension.new
      @price_manager = TurboCassandra::PriceManager.new
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

    def _create_skeleton product
      {
          description: product['description'],
          name: product['name'],
          part_number: {name: product['part_number']},
          sku: product['sku'],
          turbo_model: _create_turbo_model(product),
          turbo_type: _create_turbo_type(product)
      }
    end

    def set_catalog_visibility skeleton, product
      skeleton["visible_in_catalog"] = get_visibility(product)
    end

    def add_ti_part skeleton, product
      if not is_ti_manufacturer? product
        skeleton[:ti_part] = get_ti_interchange(product)
      else
        skeleton[:ti_part] = get_ti_itself(product)
      end
    end

    def add_oe_ref_url skeleton, product
      skeleton["oe_ref_urls"], not_externals  = get_oe_ref_url(product)
      unless not_externals.nil? and not_externals.class.name != Array
        skeleton['not_external_part_number'] = not_externals
      end
    end

    def add_critical_attributes skeleton, product
      criticals = @criticas_manager.get_critical_dimensions product
      unless criticals.nil?
        skeleton.merge!(criticals)
      end
    end

    def add_manufacturer skeleton, product
      skeleton["manufacturer"] = get_manufacturer(product)
    end

    def add_part_type skeleton, product
      skeleton["part_type"] = get_part_type(product)
    end

    def add_price skeleton, product
      price = @price_manager.get_price(product)
      unless price.nil?
        skeleton['price'] = price
      end
    end

    def add_cartridge_price skeleton
      price = @price_manager.get_cartridge_price(skeleton['ti_chra'])
      unless price.nil?
        skeleton['price'] = price
      end
    end

    def set_application skeleton, product
      skeleton['application'] = get_application(product)
    end

    def add_chras skeleton, product
      skeleton['ti_chra']= get_ti_chra(product)
      skeleton['chra']= get_foreign_chra(product)
    end

    def add_na_chras skeleton, product
      skeleton['ti_chra']= get_na_chra(product)
      skeleton['chra']= get_na_chra(product)
    end

    def add_if_not_external_manfr skeleton, product
      if is_not_external_manufacturer? product
        make_invisible(skeleton)
      end
    end

    def run product
      skeleton = _create_skeleton product
      add_ti_part(skeleton, product)
      add_oe_ref_url(skeleton, product)
      add_critical_attributes(skeleton, product)
      add_manufacturer(skeleton, product)
      add_part_type(skeleton, product)
      set_catalog_visibility(skeleton, product)
      set_application(skeleton, product)
      add_price(skeleton, product)
      if is_turbo? product
          add_chras(skeleton, product)
          add_cartridge_price(skeleton)
      else
          add_na_chras(skeleton, product)
      end
      add_if_not_external_manfr(skeleton, product)
      skeleton
    end
  end
end