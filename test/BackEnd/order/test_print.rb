require_relative 'test_helper'
class TestPrintOrder < Minitest::Test

  def setup
    @order_manager = TurboCassandra::Order.new
    @products = [

        {'base_price_incl_tax': '12.92', 'base_row_total': '12.92',
         'name': '5-A-0333',
         'oem_part': '1',
         'part_type': 'Backplate',
         'qty_ordered': '1',
         'qty_shipped': '0',
         'sku': '45069'},
        {'base_price_incl_tax': '1.7024', 'base_row_total': '1.7024', 'name': '8-A-0184', 'oem_part': '1', 'part_type': 'Piston Ring', 'qty_ordered': '1', 'qty_shipped': '0', 'sku': '46714'}

    ]

    @billing_address = {'city': 'Alabama', 'company': 'Zoral', 'country_id': 'US', 'postcode': '123456', 'region_id': '1', 'street': 'not adress', 'telephone': '3434343434'}
  end

  def products_2_cells products
    products.map { |p| [p['part_type'], p['name'], p['oem_part'], p['base_price_incl_tax'], p['qty_ordered'], p['base_row_total']] }
  end

  def table_headers
    ['Part Type', 'Name', 'Qty', 'Price', 'Qty', 'Subtotal']
  end

  def test_order_data_prepare
    order = @order_manager.find_by_id(100000308)
    order =  order.first
    product_cells = products_2_cells(order['products'])
    refute_nil product_cells
    headers = table_headers
  end



  def test_simple
    products = @products.map { |p| [p[:part_type], p[:name], p[:oem_part], p[:base_price_incl_tax], p[:qty_ordered], p[:base_row_total]] }
    order = [['Subtotal', '120'], ['Shipping', '23'], ['Grand Total', '456']]

    products.unshift(['Part Type', 'Name', 'Qty', 'Price', 'Qty', 'Subtotal'])

    ba = @billing_address.values

    Prawn::Document.generate("order_sample.pdf") do
      image "ti-logo_100x77.jpg", :width => 50, :height => 30
      move_down 5
      font  "Times-Roman", :style  => :bold
      text "Order  ID: <font size='8'> <color rgb='#FF82AB'> 11111111 </color> </font>", :inline_format => true
      move_down 20
      font  "Times-Roman", :style  => :bold
      text "Order Date: <font size='8' styles='italic'>February 18, 2016 </font>", :inline_format => true
      move_down 20

      b_cursor = cursor
      bounding_box([0, cursor], :width => 200) do
        font_size 10
        font  "Times-Roman", :style  => :bold
        text "Billing Address"
        move_down 10
        font_size 6
        font  "Times-Roman", :style  => :italic
        ba.each do |b|
          text b
          move_down 1
        end
      end
      a_cursor = cursor
      bounding_box([300, cursor + (b_cursor - a_cursor)], :width => 200) do
        font  "Times-Roman", :style  => :bold
        font_size 10
        text "Shipping Address"
        move_down 10
        font_size 6
        font  "Times-Roman", :style  => :italic
        ba.each do |b|
          text b
          move_down 1
        end
      end


      move_down 20
      font_size 10
      font  "Times-Roman", :style  => :normal
      order_table = make_table(order, :column_widths => [160, 80])

      table(products, :column_widths => [100, 150, 40, 80, 40, 80], :cell_style => { :font => "Times-Roman", :font_style => :italic})
      table([["", order_table]], :column_widths => [250, 240])
    end
  end
end