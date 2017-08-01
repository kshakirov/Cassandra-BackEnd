require "active_support/all"
module TurboCassandra
  class BaseModel

    def initialize hash
      @attributes = hash
    end

    def to_hash
      @attributes
    end

    def method_missing(m, *args, &block)
      method = m.to_s.gsub("=", '')
      if @attributes.key? method
        if args.empty?
          @attributes[method]
        else
          @attributes[method] = args.first
        end
      else
        raise "No such a field available"
      end
    end

    def self.excl_prim_ind_keys params
      params.select{|a|  not self.primary_index.include? a and
          not params[a].nil? }
    end

    def self.get_prim_ind_val params
      pairs = params.select{|a|   self.primary_index.include? a  }
      pairs.values
    end

    def save
      self.class.insert @attributes
    end

    def update
      self.class.update @attributes
    end

    def update_attributes hash
      self.class.update_attributes hash, @attributes
    end


    def self.class_name
      if self.table_name.nil?
        self.to_s.tableize.gsub('turbo_cassandra/model/', '')
      else
        self.table_name
      end
    end

    def self.insert params
      names = params.keys.join(',')
      values = params.keys.map { |key| '?' }.join(',')
      real_args =params.values
      execute(insert_template(names, values), real_args)
    end

    def self.update params
      attributes= excl_prim_ind_keys params
      key_value_pairs  = attributes.keys.map { |key| "#{key}=?" }.join(',')
      real_args =attributes.values + get_prim_ind_val(params)
      execute(update_template(key_value_pairs), real_args)
    end

    def self.update_attributes hash, attributes
      key_value_pairs = hash.keys.map { |key| "#{key}=?" }.join(',')
      real_args =hash.values + get_prim_ind_val(attributes)
      execute(update_template(key_value_pairs), real_args)
    end

    def self.aggregation_template func, aggregator
      "SELECT  #{func}(#{aggregator}) FROM #{class_name}"
    end

    def self.aggregation_params_template func, aggregator, values
      "SELECT  #{func}(#{aggregator}) FROM #{class_name} " + " WHERE #{values}"
    end

    def self.distinct_template key
      "Select distinct #{key} from #{class_name}"
    end

    def self.insert_template names, values
      "INSERT into #{class_name} (#{names}) VALUES (#{values}) "
    end

    def self.update_template key_value_pairs
      "UPDATE  #{class_name} SET #{key_value_pairs} WHERE  #{prep_primary_args}"
    end

    def self.delete_template
      "DELETE from #{class_name} " + " WHERE #{prep_primary_args}"
    end

    class << self
      attr_accessor :primary_index, :table_name
    end

    def self.select_template fields
      "Select #{fields} from #{class_name}"
    end

    def self.prep_primary_args
      if self.primary_index.class.name == 'Array'
        args = self.primary_index.map { |arg| "#{arg} = ? " }
        args.join(" AND ")
      else
        "#{self.primary_index} = ?"
      end
    end

    def self.agreg_funcs_primary_args
      if self.primary_index.class.name == 'Array'
        primary_index.first
      else
        primary_index
      end
    end

    def self.select_find_prim_template
      select_template('*') + " WHERE #{prep_primary_args}"
    end

    def self.execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

    def self.execute_paginate cql, paging_state, page_size, args=[]
      session = TurboCluster.get_session
      session.execute(cql, arguments: args, page_size: page_size, paging_state: paging_state)
    end

    def self.prep_args hash
      args = hash.values
    end

    def self.prep_where_args hash
      args = hash.keys.map { |key| "#{key} = ? " }
      args.join(" AND ")
    end

    def self.prep_where_args_in hash
      args = hash.keys.map { |key| "#{key} in   (#{hash[key].map{|v| '?'}.join(',')}) " }
      args.join(" AND ")
    end

    def self.prep_where_in_args hash
      args = hash.values.first
      args = args.map { |arg| '?' }
      args.join(",")
    end

    def self.select_find_template args
      select_template("*") + " WHERE #{args}"
    end

    def self.select_find_in_template key, args
      select_template("*") + " WHERE #{key} IN (#{args})"
    end

    def self.delete *params
      execute delete_template, params
      true
    end

    def self.find_by params
      real_args = prep_args params
      args = prep_where_args params
      fields = '*'
      results = execute(select_find_template(args), real_args)
      prep_response(results)
    end


    def self.last params, limit
      real_args = prep_args params
      args = prep_where_args params
      template = select_find_template(args) + " LIMIT #{limit[:limit]}"
      results = execute(template, real_args)
      prep_response(results)
    end


    def self.find_in_by params
      real_args = prep_args params
      args = prep_where_in_args params
      key = params.keys.first
      fields = '*'
      results = execute(select_find_in_template(key, args), real_args.first)
      prep_response(results)
    end

    def self.max params=nil
      result = nil
      if  params.nil?
        result = execute(aggregation_template('MAX', agreg_funcs_primary_args), [])
      else
        real_args = prep_args params['by']
        args = prep_where_args params['by']
        result = execute(aggregation_params_template('MAX', params['max'], args), real_args)
      end
      result.first.values.first
    end


    def self.find *params
      result = execute select_find_prim_template, params
      unless result.nil? or result.first.nil?
        return self.new result.first
      end
      nil
    end

    def self.prep_response cas_results
      unless cas_results.nil?
        cas_results.map { |r| r }
      end
    end

    def self.all
      sql = select_template '*'
      prep_response(execute(sql, []))
    end

    def self.prep_paginated_response rs
      {
          results: rs.map { |r| r },
          last: rs.last_page?,
          paging_state: rs.paging_state
      }
    end

    def self.distinct key
      results = execute(distinct_template(key), [])
      unless results.nil?
        results.map { |r| r }
      end
    end


    def self.prepare_cql hash
      if hash.values.first.class.name == "Array"
        args = hash.values.flatten
          return prep_where_args_in(hash), args
      else
        return  prep_where_args(hash),  hash.values
      end
    end


    def self.paginate paging_params, hash=nil
      cql = select_template '*'
      real_args = []
      unless hash.nil?
        args,real_args = prepare_cql(hash)
        cql = select_find_template args
      end
      rs = execute_paginate cql, paging_params['paging_state'], paging_params['page_size'], real_args
      prep_paginated_response(rs)

    end

  end

end


