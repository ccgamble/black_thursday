require_relative 'test_helper'
require_relative '../lib/invoice'
require_relative '../lib/sales_engine'

class InvoiceTest < Minitest::Test
  attr_reader :invoice, :parent, :i, :i2, :ir

  def setup

    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})

    @invoice = Invoice.new({
      :id          => 6,
      :customer_id => 7,
      :merchant_id => 8,
      :status      => "pending",
      :created_at  => Time.new.to_s,
      :updated_at  => Time.new.to_s,
    })

    @parent = Minitest::Mock.new
    @ir = @se.invoices

    @i = Invoice.new({
      :id          => 6,
      :customer_id => 7,
      :merchant_id => 8,
      :status      => "pending",
      :created_at  => Time.new.to_s,
      :updated_at  => Time.new.to_s
    }, parent)

    @i2 =  Invoice.new({
      :id          => 1,
      :customer_id => 1,
      :merchant_id => 12335938,
      :status      => "pending",
      :created_at  => "2009-02-07",
      :updated_at  => "2014-03-15"
    }, ir)

  end

  def test_it_created_instance_of_invoice_class
    assert_equal Invoice, invoice.class
  end

  def test_it_returns_id
    assert_equal 6, invoice.id
  end

  def test_it_returns_customer_id
    assert_equal 7, invoice.customer_id
  end

  def test_it_returns_merchant_id
    assert_equal 8, invoice.merchant_id
  end

  def test_it_returns_status
    assert_equal :pending, invoice.status
  end

  def test_it_knows_day_of_the_week
    assert_equal "3",invoice.day_of_the_week
  end

  def test_it_returns_current_time
    time = invoice.created_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_returns_updated_time
    time = invoice.updated_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_calls_its_parent_in_merchant
    parent.expect(:find_merchant_by_invoice_merch_id, nil, [8])
    i.merchant
    assert parent.verify
  end

  def test_it_calls_its_parent_in_invoice_items
    parent.expect(:find_invoice_items_by_invoice_id, nil, [6])
    i.invoice_items
    assert parent.verify
  end

  def test_it_calls_its_parent_in_customer
    parent.expect(:find_customer_by_invoice_customer_id, nil, [7])
    i.customer
    assert parent.verify
  end

  def test_it_calls_its_parent_in_transactions
    parent.expect(:find_transactions_by_invoice_id, nil, [6])
    i.transactions
    assert parent.verify
  end

  def test_it_can_find_items_by_invoice
    item_array = i2.items
    assert_equal Array, item_array.class
    assert_equal 8, item_array.length
  end

  def test_it_knows_invoice_is_paid_in_full
    assert i2.is_paid_in_full?
  end

  def test_it_can_find_total
    assert_equal BigDecimal,i2.total.class
    assert_equal 21067.77, i2.total.to_f
  end

end
