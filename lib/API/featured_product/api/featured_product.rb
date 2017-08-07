module TurboCassandra
  module API
    class FeaturedProduct
      include OeRefProduct

      def initialize
        @product_api = TurboCassandra::API::Product.new
      end

      def _prep_prod_hash product
        {
            sku: product['sku'],

        }
      end

      def _update product
        fp= TurboCassandra::Model::FeaturedProduct.find product['sku']
        if product['ord'] != fp.ord
          fp_ord_old =  TurboCassandra::Model::FeaturedProductOrder.find 1, product['ord']
          if  not fp_ord_old.nil?
            fp_old = TurboCassandra::Model::FeaturedProduct.find fp_ord_old.sku
            fp_ord = TurboCassandra::Model::FeaturedProductOrder.find 1, fp.ord
            fp_old.ord = fp.ord
            fp_ord_old.ord = fp.ord
            fp.ord=product['ord']
            fp_ord.ord = product['ord']
            fp.visible=product['visible']
            fp_ord.visible = product['visible']
            fp.save; fp_ord.save; fp_old.save;fp_ord_old.save
          else
            old_ord = fp.ord
            fp.ord = product['ord']
            fp.visible = product['visible']
            fp_ord =  TurboCassandra::Model::FeaturedProductOrder.find 1, old_ord
            fp_ord.ord = product['ord']
            fp_ord.visible = product['visible']
            fp.save;fp_ord.save
            TurboCassandra::Model::FeaturedProductOrder.delete 1, old_ord
          end
        else
            fp = TurboCassandra::Model::FeaturedProduct.new product
            fp.save
            product['cluster'] = 1
            fp_ord = TurboCassandra::Model::FeaturedProductOrder.new product
            fp_ord.save
        end
      end

      private
      def _get_scheleton product
        {
            description: product['description'],
            name: product['part_number'],
            part_type: product['part_type'],
            url: "/#/part/sku/#{product['sku']}",
            image_url: "/imageserver/product/#{product['sku']}/image/215/165",
            price: nil,
            turbo_model: product['turbo_model'],
            turbo_type: product['turbo_type'],
            sku: product['sku'],
            oe_ref_urls: get_oe_refs(product['interchanges'])
        }
      end

      def _create_response products
        products.map { |p|
          _get_scheleton(p)
        }
      end

      def sort products, featured_ids
        featured_ids.map do |fi|
          index = products.find_index { |p| p['sku'] == fi['sku'] }
          products[index]
        end
      end

      public
      def get_featured_products
        featured_product_ids = TurboCassandra::Model::FeaturedProductOrder.find_by visible: true
        products = @product_api.where_skus(featured_product_ids.map { |f| f['sku'] })
        products = sort(products, featured_product_ids)
        _create_response(products)
      end

      def all
        TurboCassandra::Model::FeaturedProductOrder.all
      end

      def update product
        _update product
      end

      def create product_data
        featured_product = TurboCassandra::Model::FeaturedProduct.new product_data
        featured_product.visible= true
        featured_product.save
        product_data['cluster'] = 1
        featured_product_order = TurboCassandra::Model::FeaturedProductOrder.new product_data
        featured_product_order.visible= true
        featured_product_order.save
      end

      def delete sku
        featured_product = TurboCassandra::Model::FeaturedProduct.find sku
        TurboCassandra::Model::FeaturedProductOrder.delete 1, featured_product.ord
        TurboCassandra::Model::FeaturedProduct.delete sku
      end

      def next_order
        order = TurboCassandra::Model::FeaturedProductOrder.max({'max' => 'ord', "by" => {
            "cluster": 1
        }})
        order.nil?  ? 1 : order + 1
      end

    end
  end
end