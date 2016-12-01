module TurboCassandra
  class EsApplicationMapping
      def create_application_mapping
        {
                'application': {
                    '_source': {
                        'enabled': true
        }, 'properties': {
                    'make': {
                        'type': 'string',
                        'index': 'not_analyzed'
        },
                    'model': {
                        'type': 'string',
                        'index': 'not_analyzed'
                    },
                    'id': {
                        'type': 'string',
                        'index': 'not_analyzed'
                    },
                    'year': {
                        'type': 'string',
                        'index': 'not_analyzed'
                    },
                    'engineSize': {
                        'type': 'string',
                        'index': 'not_analyzed'
                    }
                    }

                }
        }
      end
  end
end