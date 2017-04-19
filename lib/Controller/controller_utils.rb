module TurboCassandra
  module Controller
    module NotExternalManufactures
      @@not_external_manufacturer = ['I.H.I.']

      def self.is_external_manufacturer manufacturer
        index = @@not_external_manufacturer.find_index(manufacturer)
        index.nil?
      end
    end
    module Utils

      def compact_objects hashes
        if hashes.class.name == 'Hash'
          hashes.compact!
          Hash[hashes.map { |k, v| [k, compact_objects(v)] }.flatten]
        elsif hashes.class.name == "Array"
          hashes.map { |hash| compact_objects(hash) }
        end
        hashes
      end
    end
  end
end