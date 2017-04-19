module TurboCassandra
  module API
    module Batch
      module TiPart


        def _prepare_ti_part interchanges
          tis = interchanges.select { |i| i['manufacturer'] == 'Turbo International' }
          unless tis.size == 0
            return true
          end
          false
        end

        def prepare_ti_part product_hash, interchanges
          if not (interchanges.nil? or interchanges.size == 0)
            product_hash['has_ti_interchange'] = _prepare_ti_part(interchanges)
          else
            product_hash.delete 'has_ti_interchange'
          end
        end
      end
    end
  end
end