module TurboCassandra
  module API
    class ProductRecurrentUpdate
      def log product
        datum = {
            sku: product[:sku],
            date: Time.now.to_i,
            action: product[:action]
        }
        TurboCassandra::Model::SystemModel::ProductRecurrentUpdate.create datum
      end
    end
    class SystemData
      def find key_to_return, index_hash
        datum = TurboCassandra::Model::SystemModel::SystemDatum.find index_hash
        unless datum=='no match'
          datum.body[key_to_return]
        end
      end
    end
  end
end