module TurboCassandra
  class PriceManager
    include TurboTools
    public
    def initialize
      @group_price = TurboCassandra::GroupPrice.new
    end

    private
    def get_ti_part_price sku
      price  = @group_price.find sku
      if price and  price.key? 'prices'
        price['prices']
      end
    end

    def get_ti_part interchanges
      interchanges.each{|i|
        price = get_ti_part_price(i)
        unless price.nil?
          return price
        end
      }
      nil
    end

    def get_non_ti_part_price product
        if product['has_ti_interchange']
           get_ti_part(product['interchanges'])
        end
    end

    def  get_ti_chra_price ti_chra
      if ti_chra.class.name == "Array" and ti_chra.size > 0
          unless ti_chra.first[:id] .nil?
            get_ti_part_price ti_chra.first[:sku]
          end
      end

    end


    public
    def get_price product
        if is_ti_manufactured? product
            get_ti_part_price(product['sku'])
        else
            get_non_ti_part_price(product)
        end
    end

    def get_cartridge_price ti_chra
        get_ti_chra_price ti_chra
    end
  end
end