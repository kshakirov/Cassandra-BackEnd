module TurboCassandra
  module Controller
    class MessageLog
      private
      def prepare_queue rabbit_conn, queue
        channel = rabbit_conn.create_channel
        channel.queue(queue)
      end

      def prepare_incoming_message sender_email, admin_email, message
        {
            sender_email: sender_email,
            recepient_email: admin_email,
            message: message
        }
      end

      def prepare_outcoming_message recepient_emai, admin_email, message
        {
            sender_email: admin_email,
            recepient_email: recepient_emai,
            message: message
        }
      end

      def prepare_queue_payload email, action
        {
            "email": email,
             "action": action
        }.to_json
      end

      def _add_incomming sender_email, admin_email, body, payload
        message_data = prepare_incoming_message(sender_email, admin_email, body)
        @message_log_api.add_message(message_data)
        @channel.publish( payload, :routing_key => @queue)
      end
      def _add_outcomming  recepient_email, admin_email, body
        message_date = prepare_outcoming_message(recepient_email, admin_email, body)
        @message_log_api.add_message(message_date)
      end

      public
      def initialize (rabbit_conn, queue='customer_email')
        @message_log_api = TurboCassandra::API::MessageLog.new
        @queue = queue
        @channel = prepare_queue(rabbit_conn, queue)
      end

      def add_password_reset_msg read, admin_email
        request_payload = JSON.parse read
        payload = prepare_queue_payload(request_payload["email"], 'reset')
        _add_incomming(request_payload["email"],
                       admin_email, 'Reset Password', payload )
      end

      def add_password_sent_msg read, admin_email
        request_payload = JSON.parse read
        message = "New  Password " + request_payload['password']
        _add_outcomming(request_payload["email"], admin_email, message)
      end

      def add_new_customer_msg read, admin_email
        request_payload = JSON.parse read
        payload = prepare_queue_payload(request_payload["email"], 'new')
        _add_incomming(request_payload["email"], admin_email, 'New Customer', payload)
      end

      def add_new_customer_sent_msg read, admin_email
        request_payload = JSON.parse read
        message = "New  Customer [#{request_payload['email']}],  new password   [ #{request_payload['password']}]"
        _add_outcomming(request_payload["email"], admin_email, message)
      end




    end
  end

end