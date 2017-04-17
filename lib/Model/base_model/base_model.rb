require "active_support/all"
module TurboCassandra
  class BaseModel

    def initialize hash
      @attributes = hash
    end

    def save
      self.class.insert @attributes
    end


    def self.class_name
      self.to_s.tableize.gsub('turbo_cassandra/','')
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

    def self.select_find_prim_template
      select_template('*') + " WHERE #{@@primary_index} = ?"
    end

    def self.execute cql, args
      session = TurboCluster.get_session
      statement = session.prepare(cql)
      session.execute(statement, arguments: args, consistency: :one)
    end

    def self.prep_args hash
      args = hash.values
    end

    def self.prep_where_args hash
      args = hash.keys.map { |key| "#{key} = ? " }
      args.join(" AND ")
    end

    def self.select_find_template args
      select_template("") + " WHERE #{args}"
    end

    def self

    end

    def self.find_by params
      real_args = prep_args params
      args = prep_where_args params
      fields = '*'
      result = execute(select_find_template(args), real_args)
    end

    def self.find_all

    end

    def self.find param
      execute select_find_prim_template, [param]
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

  end

end


