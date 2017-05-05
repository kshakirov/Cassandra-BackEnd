module TurboCassandra
  module Controller
    class MessageLog
      include MessageLogPagination
      private
      def prepare_queue rabbit_conn, queue
        channel = rabbit_conn.create_channel
        channel.queue(queue)
      end

      def is_email_unique? email
        customers = TurboCassandra::Model::Customer.find_by email: email
        unless customers.empty?
          raise 'Email Is Already Used'
        end
        true
      end

      def is_email_available? email
        customers = TurboCassandra::Model::Customer.find_by email: email
        if customers.empty?
          raise 'No User With This Email'
        end
        true
      end

      def prepare_incoming_message customer_email, message
        {
            customer_email: customer_email,
            message: message,
            status: 'Queued'
        }
      end

      def prepare_outcoming_message request
        {
            message: request['message'],
            status: request['status'],
            date_end: Time.now.to_time
        }
      end

      def prepare_queue_payload email, action, message_id
        {
            "email": email,
            "action": action,
            "id": message_id.to_s
        }.to_json
      end

      def prepare_order_queue_payload request, message_id
        {
            "email": request['email'],
            "order_id": request['order_id'],
            "action": 'order',
            "id": message_id.to_s
        }.to_json
      end

      def prepare_notify_queue_payload request, message_id
        {
            "email": request['email'],
            "notification_code": 'send_user_data',
            "action": 'notification',
            "id": message_id.to_s,
            "data": {
                "login": request['login'],
                "authentication_node": get_auth_node(request),
                "password": get_password(request)
            }
        }.to_json
      end

      def get_auth_node request
        if not request['authentication_node'] == 'Internal'
          node = @authentication_node.get_node(request['authentication_node'])
          node.base_dn
        else
          "Internal"
        end
      end

      def get_password request
        if request['authentication_node'] == 'Internal'
          request['password']
        else
          "use your external password"
        end
      end

      def log_task customer_email, message
        message_data = prepare_incoming_message(customer_email, message)
        @message_log_api.add_message(message_data)
      end

      def publish_task payload
        @channel.publish(payload, :routing_key => @queue)
      end

      def commit_log request
        message_data = prepare_outcoming_message(request)
        message_id = Cassandra::TimeUuid.new(request['id'])
        @message_log_api.update_message_by_id(request['email'],
                                              message_id, message_data)
        {
            result: true
        }
      end

      public
      def initialize (rabbit_conn, queue='customer_email')
        @message_log_api = TurboCassandra::API::MessageLog.new
        @authentication_node = TurboCassandra::API::AuthenticationNode.new
        @customer_api = TurboCassandra::API::Customer.new
        @queue = queue
        @channel = prepare_queue(rabbit_conn, queue)
      end

      def queue_password_reset_task read
        request = JSON.parse read
        if is_email_available? request['email']
          message_id = log_task(request["email"], "Customer [#{request['email']}] Queued To Reset Password")
          queue_payload = prepare_queue_payload(request["email"], 'reset', message_id)
          publish_task(queue_payload)
        end
      end


      def queue_order_task body
        request = JSON.parse body
        message_id = log_task(request["email"], "Order [#{request['order_id']}] Queued To Email")
        task_payload = prepare_order_queue_payload(request, message_id)
        publish_task(task_payload)
      end


      def log_task_complete body
        request_payload = JSON.parse body
        commit_log(request_payload)
      end

      def queue_new_customer_task read
        request = JSON.parse read
        if is_email_unique? request['email']
          message_id = log_task(request["email"], 'New Customer')
          queue_payload = prepare_queue_payload(request["email"], 'new', message_id)
          publish_task(queue_payload)
        end
      end

      def log_new_customer_task read
        request_payload = JSON.parse read
        message = "New  Customer [#{request_payload['email']}],  new password   [ #{request_payload['password']}]"
        commit_log(request_payload)
      end

      def queue_user_notification request
        message_id = log_task(request["email"], "User Data [#{request['']}] Queued To Email")
        task_payload = prepare_notify_queue_payload(request, message_id)
        publish_task(task_payload)
      end

    end
  end

end