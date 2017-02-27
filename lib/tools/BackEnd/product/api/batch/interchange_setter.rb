module TurboCassandra
  module API
    module Batch
      module Interchange
        def _prepare_interchanges interchanges
          interchanges.map { |i| i['id'].to_i }
        end

        def prepare_interchanges  product_hash, interchanges
          if not (interchanges.nil? or interchanges.size == 0)
            product_hash['interchanges'] = _prepare_interchanges(interchanges)
          else
              product_hash.delete 'interchanges'
          end
        end
      end
    end
  end
end