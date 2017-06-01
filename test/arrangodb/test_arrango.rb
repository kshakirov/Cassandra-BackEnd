require 'arangorb'
require 'minitest/autorun'
require 'minitest/pride'
require 'active_support/all'
require_relative '../../lib/SystmeModel/base_model/base_system_model'
require_relative '../../lib/SystmeModel/models/models'

class TestArango < Minitest::Test
  def test_sys_daat
    # response = TurboCassandra::Model::SystemModel::SystemDatum.all
    # p response
    response = TurboCassandra::Model::SystemModel::ProductRecurrentUpdate.all
    p response
  end

  def test_add_document
    system_datum = {
        name: "test_add_document"
    }
    TurboCassandra::Model::SystemModel::SystemDatum.create system_datum

    product_datum = {
        name: "test_add_product_update"
    }
    TurboCassandra::Model::SystemModel::ProductRecurrentUpdate.create product_datum
  end


  def test_delete_document
    system_datum = {
        name: "test_add_document"
    }
    TurboCassandra::Model::SystemModel::SystemDatum.delete system_datum
    product_datum = {
        name: "test_add_product_update"
    }

    TurboCassandra::Model::SystemModel::ProductRecurrentUpdate.delete product_datum
  end


  def test_add_updated_product


    100.times do |up|
      product_datum = {
          sku: up,
          date: Time.now.to_i
      }
      p product_datum[:date]
      TurboCassandra::Model::SystemModel::ProductRecurrentUpdate.create product_datum
    end
  end

  def test_sys_data

    values = [
        {
            name: 'elastic_instance', ip: '10.1.3.16'
        },
        {
            name: 'metadata_instance', ip: 'timms.turbointernational.com'
        },
        {
            name: 'elastic_index', id: 'turbo_development'
        },
    ]
    values.each do |value|
      TurboCassandra::Model::SystemModel::SystemDatum.create value
    end
  end
end
