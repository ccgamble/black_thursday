require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test
  def setup
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @sa = SalesAnalyst.new(se)
  end

  def test_it_created_an_instance_of_sales_analyst_class
    skip
    assert_equal SalesAnalyst, @sa.class
  end

  def test_it_can_find_the_average
    skip
    average = @sa.average_items_per_merchant
    assert average
    assert_equal 2.88, average
  end

  def test_it_can_find_average_item_price_for_merchant
    skip
    average = @sa.average_item_price_for_merchant(12337411)
    assert average
    assert_equal 30.00, average
  end

  def test_it_can_find_average_average_price_per_merchant
    skip
    average = @sa.average_average_price_per_merchant
    assert average
    assert_equal 350.29, average
  end

  def test_it_can_return_standard_deviation
    skip
    std_dev = @sa.average_items_per_merchant_standard_deviation
    assert_equal 3.26, std_dev
  end

  def test_it_can_find_merchants_with_high_item_count
    skip
    merchants = @sa.merchants_with_high_item_count
    assert_equal Array, merchants.class
    assert_equal Merchant, merchants[0].class
  end

  def test_it_can_find_golden_items
    skip
    items = @sa.golden_items
    assert_equal Array, items.class
    assert_equal Item, items[0].class
  end

  def test_it_can_find_average_invoices_per_merchant
    skip
    avg = @sa.average_invoices_per_merchant
    assert_equal 10.49, avg
  end

  def test_it_can_find_avg_invoices_per_merch_std_dev
    skip
    std_dev = @sa.average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, std_dev
  end

  def test_it_can_find_top_merchants_by_invoice_count
    skip
    top_merchants = @sa.top_merchants_by_invoice_count
    assert_equal Array, top_merchants.class
    assert_equal Merchant, top_merchants[0].class
  end

  def test_it_can_find_bottom_merchants_by_invoice_count
    skip
    bottom_merchants = @sa.bottom_merchants_by_invoice_count
    assert_equal Array, bottom_merchants.class
    assert_equal Merchant, bottom_merchants[0].class
  end

  def test_it_can_find_percentage_of_invoices_by_status
    skip
    assert_equal 29.55, @sa.invoice_status(:pending)
    assert_equal 56.95, @sa.invoice_status(:shipped)
    assert_equal 13.5, @sa.invoice_status(:returned)
  end

  def test_it_returns_a_revenue_by_merchant
    skip
    revenue = @sa.revenue_by_merchant(12334105)
    assert_equal BigDecimal, revenue.class
    assert_equal 73777.17, revenue.to_f
  end

  def test_it_returns_top_merchant_by_revenue
    skip
    top_merchant = @sa.top_revenue_earners(1)
    assert_equal Merchant, top_merchant[0].class
    assert_equal 12334634,top_merchant[0].id
  end

  def test_it_finds_merchants_with_only_one_item
    merchants = @sa.merchants_with_only_one_item
    assert_equal Array, merchants.class
    assert_equal Merchant, merchants[0].class
  end

  def test_it_can_find_merchants_with_pending_invoices
    merchants = @sa.merchants_with_pending_invoices
    assert_equal Array, merchants.class
    assert_equal Merchant, merchants[0].class
  end

  def test_it_can_find_most_sold_item_for_a_merchant
    item = @sa.most_sold_item_for_merchant(12334105)
    assert_equal Array, item.class
    assert_equal Item, item[0].class
  end

end
