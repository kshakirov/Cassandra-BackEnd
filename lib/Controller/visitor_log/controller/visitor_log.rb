module TurboCassandra
  module Controller
    class VisitorLog
      def initialize
        @visitor_log_api = TurboCassandra::API::VisitorLog.new
      end

      def new_visit request
        request.body.rewind
        payload = JSON.parse request.body.read
        visit_data = {
            visitor_id: request.env['HTTP_X_VISITOR'].to_i,
            ip: request.env['REMOTE_ADDR'],
            product: payload['sku'].to_i
        }
        @visitor_log_api.create visit_data
      end

      def last_5_visits request
        id = request.env['HTTP_X_VISITOR'].to_i
        nth = 5
         @visitor_log_api.last_nth id, nth
      end

      def new_customer_visit request, params
        customer_id = request.env.values_at( :customer).first['id']
        sku = params[:id].to_i
        visit_data = {
        customer_id: customer_id,
            ip: request.env['REMOTE_ADDR'],
            product: sku
        }
        @visitor_log_api.create_customer_visit visit_data
      end

      def last_5_customer_visits request
        customer_id = request.env.values_at( :customer).first['id']
        @visitor_log_api.last_nth_customer customer_id
      end

    end
  end
end