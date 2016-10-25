module TurboCassandra
  class GroupPriceBatch
    def prepare_group_price hash
      hash['sku'] = hash['partId']
      hash.delete('partId')
    end
  end
end