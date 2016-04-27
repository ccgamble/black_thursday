require_relative 'test_helper'
require_relative '../lib/customer'
require_relative '../lib/sales_engine'

class CustomerTest < Minitest::Test
  attr_reader :c, :customers

  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})

    @customers = @se.customers

    @c = Customer.new({
    :id => 6,
    :first_name => "Joan",
    :last_name => "Clarke",
    :created_at => Time.new.to_s,
    :updated_at => Time.new.to_s
    })

  end

  def test_it_created_instance_of_invoice_class
    assert_equal Customer, c.class
  end

  def test_it_returns_id
    assert_equal 6, c.id
  end

  def test_it_returns_first_name
    assert_equal "Joan", c.first_name
  end

  def test_it_returns_last_name
    assert_equal "Clarke", c.last_name
  end

  def test_it_returns_current_time
    time = c.created_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_returns_updated_time
    time = c.updated_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_can_return_parent_when_merchants_is_called
    cust = Customer.new({:id => 1,
      :first_name => "Joey",
      :last_name => "Ondricka",
      :created_at => "2012-03-27 14:54:09 UTC",
      :updated_at => "2012-03-27 14:54:09 UTC"}, customers)
      merchant_array = cust.merchants
    assert_equal Array, merchant_array.class
    assert_equal 8, merchant_array.length
  end
end
