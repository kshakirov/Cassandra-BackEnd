module TurboCassandra
  module TcasService
    private

    def query_bom_service product
      unless product['cartridges'].nil?
        return product['cartridges']
      end
      []
    end

    def query_interchange_service product
      unless product['interchanges'].nil?
        product['interchanges'].map do |interchange|
          @product_api.find_by_sku interchange
        end
      end
    end
  end
end