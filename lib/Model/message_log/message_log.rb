module TurboCassandra
  module Model
    class MessageLog < BaseModel
      self.primary_index ['customer_email', 'id']

      def save
        super
        if @attributes.key? 'id'
          @attributes['id'].to_s
        else
          @attributes[:id].to_s
        end
      end
    end
  end
end
