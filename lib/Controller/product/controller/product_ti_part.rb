module TurboCassandra
  module Controller
    module TiPart

      def is_ti_product?  product
        product['manufacturer'] == 'Turbo International'
      end

      def create_response tis
        if tis.size > 0
          return  tis.first['sku'], tis.first['part_number']
        else
          return nil, nil
        end
      end

      def get_interchanged_products interchanges
        interchanges.map  do |i|
          @product_api.find_by_sku(i)
        end
      end

      def get_ti_part interchanges
        tis = get_interchanged_products(interchanges)
        tis = tis.select{|i| is_ti_product?(i) }
        create_response(tis)
      end
      def add_ti_part_attributes product
          if product['interchanges']
            get_ti_part(product['interchanges'])
          else
            return nil, nil
          end
      end
    end
  end
end