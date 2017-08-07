module TurboCassandra
  module API
    class NewProduct
      include OeRefProduct
      private
      def sort products, new_ids
        new_ids.compact.map do |ni|
          index = products.find_index{|p|
            p['sku'] == ni
          }
          products[index]
        end
      end

      def get_next_order
        @featured_product_api.next_order
      end

      def populate_featured_product product
        {
            sku: product['sku'],
            ord: get_next_order,
            visible: false,
            part_number: product['part_number']
        }
      end

      def _update product
        np= TurboCassandra::Model::NewProduct.find product['sku']
        if product['ord'] != np.ord
          np_ord_old =  TurboCassandra::Model::NewProductOrder.find 1, product['ord']
          if  not np_ord_old.nil?
            np_old = TurboCassandra::Model::NewProduct.find np_ord_old.sku
            np_ord = TurboCassandra::Model::NewProductOrder.find 1, np.ord
            np_old.ord = np.ord
            np_ord_old.ord = np.ord
            np.ord=product['ord']
            np_ord.ord = product['ord']
            np.visible=product['visible']
            np_ord.visible = product['visible']
            np.save; np_ord.save; np_old.save;np_ord_old.save
          else
            old_ord = np.ord
            np.ord = product['ord']
            np.visible=product['visible']
            np_ord =  TurboCassandra::Model::NewProductOrder.find 1, old_ord
            np_ord.ord = product['ord']
            np_ord.visible = product['visible']
            np.save;np_ord.save
            TurboCassandra::Model::NewProductOrder.delete 1, old_ord
          end
        else
          np = TurboCassandra::Model::NewProduct.new product
          np.save
          product['cluster'] = 1
          np_ord = TurboCassandra::Model::NewProductOrder.new product
          np_ord.save
        end
      end

      public
      def initialize
        @product_api = TurboCassandra::API::Product.new
      end

      def all
        TurboCassandra::Model::NewProductOrder.all
      end

      def create product_data
        new_product = TurboCassandra::Model::NewProduct.new product_data
        new_product.visible= true
        new_product.save
        product_data['cluster'] = 1
        new_product_order = TurboCassandra::Model::NewProductOrder.new product_data
        new_product_order.visible= true
        new_product_order.save
      end

      def delete sku
        new_product = TurboCassandra::Model::NewProduct.find sku
        TurboCassandra::Model::NewProductOrder.delete 1, new_product.ord
        TurboCassandra::Model::NewProduct.delete sku
      end

      def update product
       _update product
      end

      def _get_scheleton product
        {
            description: product['description'],
            name: product['part_number'],
            part_type: product['part_type'],
            url: "/#/part/sku/#{product['sku']}",
            image_url: "/imageserver/product/#{product['sku']}/image/215/165",
            price: nil,
            sku: product['sku'],
            turbo_model: product['turbo_model'],
            turbo_type: product['turbo_type'],
            oe_ref_urls: get_oe_refs(product['interchanges'])
        }
      end

      def _create_response products
        products.map { |p| _get_scheleton(p) }
      end

      def get_new_products
        new_product_ids = TurboCassandra::Model::NewProductOrder.find_by visible: true
        products = @product_api.where_skus(new_product_ids.map{|n| n['sku']})
        products = sort(products, new_product_ids.map{|n| n['sku']})
        _create_response(products)
      end

      def next_order
        order = TurboCassandra::Model::NewProductOrder.max(
            {
                'max' => 'ord',
             "by" => {
              "cluster" => 1
        }})
        order.nil?  ? 1 : order + 1
      end
    end

  end
end