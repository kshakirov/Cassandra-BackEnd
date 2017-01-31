module TurboCassandra
  class ComparedProducts
    include TurboCassandra::Utils
    private

    def create_insert_cql names, values
      "INSERT INTO compared_products  (#{names}) " \
            "VALUES (#{values})"
    end
    def select_by_customer_id_cql
      "SELECT * from  compared_products where customer_id = ?"
    end

    def delete_by_id_sql
      "Delete   from  compared_products where customer_id = ? and product = ?"
    end

    def _insert hash
      names, values, args = prepare_attributes(hash)
      execute_query(create_insert_cql(names, values), args)
    end

    def _delete customer_id, product
      execute_query(delete_by_id_sql, [customer_id, product])
      true
    end

    def _find customer_id
      cmp = execute_query(select_by_customer_id_cql, [customer_id])
      if cmp and cmp.size
          cmp.map{|c| c['product']}
      end
    end

    public

    def find  customer_id
      _find(customer_id)
    end

    def insert data
        _insert(data)
      true
    end
    def delete customer_id, product
      _delete(customer_id, product)
    end

  end
end