module TurboCassandra

  class AttributeBatch
    def adopt_hash hash
        _options_hash = hash['options']
        _option_hash = _options_hash['option']
        _options_hash.delete('option')
        hash.delete('options')
        _options_hash['options'] = _option_hash['values'] if  _option_hash and  _option_hash.key? 'values'
      hash.merge(_options_hash)
    end
  end


  class Attribute
    def remove_null_values attr_properties
      attr_properties.select{|k,v| not v.nil?}
    end
    def  prepare_names properties
        properties.keys.map{|k| k.to_s}.join(",")
    end

    def prepare_values properties
      properties.map{|p| '?'}.join(",")
    end

    def prepare_args properties
      properties.values
    end

    def prepare_attributes attr_properties
        properties = remove_null_values(attr_properties)
        return  prepare_names(properties), prepare_values(properties), prepare_args(properties)
    end

    def create_insert_cql names, values
       "INSERT INTO attributes  (#{names})  VALUES (#{values})"
    end

    def create_select_where_cql
      "SELECT * from  attributes  WHERE code=?"
    end

    def select_all_cql
      "SELECT * from  attributes "
    end

    def create_select_where_by_set_cql
      "SELECT * from  attributes  WHERE attribute_set=?"
    end

    def insert attr_properties
        names, values, args = prepare_attributes attr_properties
        cql = create_insert_cql(names, values)
        execute(cql, args)
    end
    def find code
        execute(create_select_where_cql(), [code])
    end

    def find_by_set_name name
      execute(create_select_where_by_set_cql,[name]).map{|a| a}
    end

    def all
        execute(select_all_cql, [])
    end

    def find_all
      execute(select_all_cql, []).map{|a| a}
    end

    def execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

  end
end