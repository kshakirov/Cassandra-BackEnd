module TurboCassandra
  class VisitorLogBackEnd
    private
    def initialize
      @visitor_logs = TurboCassandra::VisitorLog.new
      @customer_logs = TurboCassandra::CustomerLog.new
      @generator = Cassandra::Uuid::Generator.new
      @product_controller = TurboCassandra::Controller::Product.new
    end

    def add_customer_id hash
      unless hash.key? :customer_id
        hash[:customer_id] = 0
      end
    end

    def add_visitor_id hash
      if hash.key? :visitor_id and hash[:visitor_id]
        hash[:visitor_id] = Cassandra::Types::Uuid.new(hash[:visitor_id])
      end
    end


    def prepare_data hash
      hash[:ip] = Cassandra::Types::Inet.new(hash[:ip])
      hash[:date] = Time.now.to_time
      hash[:id] = @generator.now
      hash
    end


    public
    def new_visit hash
      log = prepare_data(hash)
      add_visitor_id(log)
      @visitor_logs.insert(log)
    end

    def new_customer_visit hash
      log = prepare_data(hash)
      add_visitor_id(log)
      @customer_logs.insert(log)
    end

    def last5_customer id
      skus = @customer_logs.last({:key => 'customer_id', :value => id}).map { |cl| cl['product'] }
      unless skus.nil?
        @product_controller.get_products(skus).map { |p| {sku: p['sku'], name: "#{p['part_type']} - #{p['part_number']}"} }
      end
    end

    def last5_visitor id
      uuid = Cassandra::Types::Uuid.new(id)
      skus = @visitor_logs.last({:key => 'visitor_id', :value => uuid}).map { |vl| vl['product'] }
      unless skus.nil?
        @product_controller.get_products(skus).map { |p| {sku: p['sku'], name: "#{p['part_type']} - #{p['part_number']}"} }.to_json
      end
    end

  end
end