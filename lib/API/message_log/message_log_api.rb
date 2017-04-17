module TurboCassandra
  module API
    class MessageLog
      private
      def _add_message message_data
        message = {
            customer_email: message_data[:customer_email],
            id: @generator.now,
            status: message_data[:status],
            date_start:  Time.now.to_time,
            message: message_data[:message]
        }
        new_message = TurboCassandra::Model::MessageLog.new message
        new_message.save
      end

      def _get_message_by_sender_email email

        TurboCassandra::Model::MessageLog.find_by customer_email: email
      end

      public
      def initialize
        @generator = Cassandra::Uuid::Generator.new
      end

      def add_message message_data
        _add_message(message_data)
      end

      def get_message_by_sender_email  email
          _get_message_by_sender_email(email)
      end

      def paginate params
        @message_log_model.paginate params
      end

      def update_message_by_id email, id, message_data
        message = TurboCassandra::Model::MessageLog.find email, id
        message.customer_email=message_data[:customer_email]
        message.message= message_data[:message]
        message.status= message_data[:status]
        message.save
      end
    end
  end

end