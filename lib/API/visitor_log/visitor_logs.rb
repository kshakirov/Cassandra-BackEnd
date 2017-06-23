module TurboCassandra
  module API
    class VisitorLog
      def initialize
        @customer_logs = TurboCassandra::CustomerLog.new
        @generator = Cassandra::Uuid::Generator.new
        @product_controller = TurboCassandra::Controller::Product.new
      end

      private
      def add_customer_id hash
        unless hash.key? :customer_id
          hash[:customer_id] = 0
        end
      end

      def prepare_data visit_data
        visit_data[:ip] = Cassandra::Types::Inet.new(visit_data[:ip])
        visit_data[:date] = Time.now.to_time
        visit_data[:id] = @generator.now
        visit_data
      end


      public
      def create visit_data
        hash = prepare_data(visit_data)
        logger = TurboCassandra::Model::VisitorLog.new hash
        logger.save

      end

      def create_customer_visit visit_data
        log = prepare_data(visit_data)
        @customer_logs.insert(log)
      end

      def last_nth_customer id
        skus = @customer_logs.last({:key => 'customer_id', :value => id}).map {|cl| cl['product']}
        unless skus.nil?
          @product_controller.get_products(skus).map {|p| {sku: p['sku'], name: "#{p['part_type']} - #{p['part_number']}"}}
        end
      end

      def last_nth  id, nth
        products = TurboCassandra::Model::VisitorLog.find_by visitor_id: id
        skus = products.map {|vl| vl['product']}
        unless skus.nil?
          @product_controller.get_products(skus).map {|p| {sku: p['sku'], name: "#{p['part_type']} - #{p['part_number']}"}}
        end
      end

    end
  end
end