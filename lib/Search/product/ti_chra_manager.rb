module TurboCassandra

  module TiChraManager
    private

    def has_ti_chra? product
      product['has_ti_chra']
    end

    def _get_ti_chra product
      cartridges = query_bom_service(product)
      cartridges.select { |b| b['manufacturer']== 'Turbo International' }
    end

    def _get_foreign_chra product
      cartridges = query_bom_service(product)
      cartridges.select { |b| b['manufacturer'] != 'Turbo International' }
    end

    def prepare_ti_chra product
      ti_chra = _get_ti_chra(product)
      if ti_chra.class.name == "Array"
        ti_chra.map { |ch|
          {
              part_number: ch['part_number'],
              url: "/#/part/sku/#{ch['sku']}",
              sku: ch['sku'].to_i,
              id: 1
          }
        }
      end
    end

    def prepare_foreign_chra product
      chra = _get_foreign_chra(product)
      if chra.class.name == "Array"
        chra.map { |ch|
          {
              part_number: ch['part_number'],
              url: "/#/part/sku/#{ch['sku']}",
              sku: ch['sku'], id: 1
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