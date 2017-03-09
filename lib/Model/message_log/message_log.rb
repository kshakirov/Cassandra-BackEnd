module TurboCassandra
  module Model
    class MessageLog
      include TurboCassandra::Model::Utils
      private

      def insert_cql names, values
        "INSERT INTO message_logs  (#{names}) " \
            "VALUES (#{values})"
      end

      def select_by_sender_email_cql
        "SELECT * from  message_logs WHERE sender_email=? "
      end

      public
      def insert hash
        names, values, args = prepare_attributes(hash)
        execute_query(insert_cql(names, values), args)
        true
      end

      def find_by_sender_email email
        result = execute_query(select_by_sender_email_cql, [email])
        result.map{|r| r}
      end
    end
  end
end
