module TurboCassandra
  class VisitorLogBackEnd
    private
    def initialize
      @visitor_logs = TurboCassandra::VisitorLog.new
      @generator = Cassandra::Uuid::Generator.new
      @customer_default_uuid = '79e5893d-2f60-4fbe-aa7a-84d28d6e614f'
    end

    def add_customer_id hash
      unless hash.key? :customer_id
        hash[:customer_id] = 0
      end
    end

    def add_visitor_id  hash
      if hash.key? :visitor_id
        hash[:visitor_id] = Cassandra::Types::Uuid.new(hash[:visitor_id])
      else
        hash[:visitor_id] = Cassandra::Types::Uuid.new(@customer_default_uuid)
      end
    end

    def prepare_data  hash
      hash[:ip] = Cassandra::Types::Inet.new(hash[:ip])
      hash[:date] = Time.now.to_time
      hash[:id] =  @generator.now
      add_visitor_id(hash)
      add_customer_id(hash)
      hash
    end
    public
    def new hash
      @visitor_logs.insert(prepare_data(hash))
    end
    def last5_customer id
      @visitor_logs.last({ :key  => 'customer_id', :value => id })
    end

    def last5_visitor id
      @visitor_logs.last({ :key  => 'visitor_id' , :value => id})
    end

  end
end