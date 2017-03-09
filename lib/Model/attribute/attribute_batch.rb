module TurboCassandra
  module Model
    class AttributeBatch
      def adopt_hash hash
        _options_hash = hash['options']
        _option_hash = _options_hash['option']
        _options_hash.delete('option')
        hash.delete('options')
        _options_hash['options'] = _option_hash['values'] if _option_hash and _option_hash.key? 'values'
        hash.merge(_options_hash)
      end
    end
  end
  end