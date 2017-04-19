module TurboCassandra
  module NotExternalManufacturer
    @@not_external_manufacturer = ['I.H.I.']
    private
    def is_not_external_manufacturer? product
      key = nil
      if product.key? 'manufacturer'
        key= 'manufacturer'
      elsif product.key? :manufacturer
        key= :manufacturer
      end
      index = @@not_external_manufacturer.find_index(product[key])
      not index.nil?
    end

    public

    def make_invisible skeleton
        skeleton['invisible_in_search'] = true
        skeleton['visible_in_catalog'] = false
    end

  end
end