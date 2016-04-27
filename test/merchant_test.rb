require_relative 'test_helper'
require_relative '../lib/merchant'
require_relative '../lib/sales_engine'
require 'time'

class MerchantTest < Minitest::Test
  attr_reader :test_data, :test_data2, :se, :merch

  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @merch = @se.merchants
    @test_data = {:id => 5, :name => "Turing School", :created_at => "2015-12-10"}
    @test_data2 = {:id => 12334105, :name => "Shopin1901", :created_at => "2015-12-10"}
  end

  def test_it_created_instance_of_merchant_class
    m = Merchant.new(test_data)
    assert_equal Merchant, m.class
  end

  def test_it_returns_the_id_of_the_merchant
    m = Merchant.new(test_data)
    assert_equal 5, m.id
  end

  def test_it_returns_the_name_of_the_merchant
    m = Merchant.new(test_data)
    assert_equal "Turing School", m.name
  end

  def test_it_can_return_parent_when_items_is_called
    parent = Minitest::Mock.new
    m = Merchant.new(test_data, parent)
    parent.expect(:find_items_by_merchant_id, nil, [5])
    m.items
    assert parent.verify
  end

  def test_it_can_return_parent_when_invoices_is_called
    parent = Minitest::Mock.new
    m = Merchant.new(test_data, parent)
    parent.expect(:find_invoices_by_merchant_id, nil, [5])
    m.invoices
    assert parent.verify
  end

  def test_it_can_return_when_merchant_was_created
    m = Merchant.new(test_data)
    created = m.created_at
    assert_equal Time, created.class
    assert_equal 2015, created.year
  end

  def test_it_can_return_parent_when_customers_is_called
    m = Merchant.new(test_data2, @merch)
    customers = m.customers
    assert_equal Array, customers.class
    assert_equal 10, customers.length
  end

end
