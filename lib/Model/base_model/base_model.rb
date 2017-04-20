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
      method = m.to_s.gsub("=",'')
      if @attributes.key? method
        @attributes[method] = args.first
      else
        raise "No such a field available"
      end
    end

    def save
      self.class.insert @attributes
    end


    def self.class_name
      self.to_s.tableize.gsub('turbo_cassandra/model/','')
    end

    def self.insert params
      names = params.keys.join(',')
      values = params.keys.map { |key| '?' }.join(',')
      real_args =params.values
      execute(insert_template(names, values), real_args)
    end

    def self.insert_template names, values
      "INSERT into #{class_name} (#{names}) VALUES (#{values}) "
    end

    def self.primary_index index
      @@primary_index = index
    end

    def self.select_template fields
      "Select #{fields} from #{class_name}"
    end

    def self.prep_primary_args
      if @@primary_index.class.name == 'Array'
        args = @@primary_index.map { |arg| "#{arg} = ? " }
        args.join(" AND ")
      else
        "#{@@primary_index} = ?"
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

    def self.execute_paginate cql, paging_state, page_size,args=[]
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

    def self.select_find_template args
      select_template("*") + " WHERE #{args}"
    end

    def self

    end

    def self.find_by params
      real_args = prep_args params
      args = prep_where_args params
      fields = '*'
      results = execute(select_find_template(args), real_args)
      prep_response(results)
    end

    def self.find_all

    end

    def self.find *params
      result = execute select_find_prim_template, params
      unless result.nil?
       self.new result.first
      end
    end

    def self.prep_response cas_results
      unless cas_results.nil?
        cas_results.map{|r| r}
      end
    end

    def self.all
     sql = select_template '*'
     prep_response(execute(sql,[]))
    end

    def self.prep_paginated_response rs
      {
          results: rs.map{|r| r},
          last: rs.last_page?,
          paging_state: rs.paging_state
      }
    end

    def self.paginate paging_params, hash=nil
      cql = select_template '*'
      real_args = []
      unless hash.nil?
        args = prep_where_args hash
        real_args = hash.values
        cql = select_find_template args
      end
      rs = execute_paginate cql,paging_params['paging_state'], paging_params['page_size'], real_args
      prep_paginated_response(rs)

    end

  end

end


