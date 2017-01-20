module TurboCassandra

  class TiChraManager
    private

    def has_ti_chra? product
      product['has_ti_chra']
    end

    def query_bom_service sku
      response = RestClient.get("http://attribute_server:4571/product/#{sku}/bom/")
      begin
        JSON.parse response.body
      rescue
        []
      end
    end

    def _get_ti_chra product
      boms = query_bom_service(product['sku'])
      boms.select { |b|
        b['part_type'] == 'Cartridge' and not b['part_number'].nil?
      }
    end

    def _get_foreign_chra product
      boms = query_bom_service(product['sku'])
      boms.select { |b|
        b['part_type'] == 'Cartridge' and not b['oe_part_number'].nil?
      }
    end

    def prepare_ti_chra product
      ti_chra = _get_ti_chra(product)
      if ti_chra.class.name == "Array"
        ti_chra.map { |ch|
          {
              part_number: ch['part_number'],
              url: "/#/part/sku/#{ch['sku']}",
              sku: ch['sku'], id: 1
          }
        }
      end
    end

    def prepare_foreign_chra product
      chra = _get_foreign_chra(product)
      if chra.class.name == "Array"
        chra.map { |ch|
          {
              part_number: ch['oe_part_number'],
              url: "/#/part/sku/#{ch['oe_sku']}",
              sku: ch['oe_sku'], id: 1
          }
        }
      end
    end

    public

    def get_ti_chra product
      if has_ti_chra?(product)
        prepare_ti_chra(product)
      end
    end

    def get_foreign_chra product
      prepare_foreign_chra(product)
    end

    def get_na_chra product
      {
          part_number: "N/A",
          url:  nil,
          id: nil
      }
    end

  end
end