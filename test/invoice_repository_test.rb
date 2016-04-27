require_relative 'test_helper'
require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'


class InvoiceRepositoryTest < Minitest::Test
  attr_reader :inv

  def setup
    invoice1 = Invoice.new({
    :id          => 6,
    :customer_id => 7,
    :merchant_id => 8,
    :status      => "pending",
    :created_at  => Time.new.to_s,
    :updated_at  => Time.new.to_s,
    })

    invoice2 = Invoice.new({
    :id          => 9,
    :customer_id => 38,
    :merchant_id => 93,
    :status      => "shipped",
    :created_at  => Time.new.to_s,
    :updated_at  => Time.new.to_s,
    })

    @invoice = InvoiceRepository.new
    @invoice.invoice_repository = ([invoice1, invoice2])

    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @inv = @se.invoices
  end

  def test_it_creates_a_new_instance_of_invoice_repo
    assert_equal InvoiceRepository, @invoice.class
  end

  def test_it_inspects
    assert @invoice.inspect
  end

  def test_it_starts_out_empty
    ir = InvoiceRepository.new
    assert ir.invoice_repository.empty?
  end

  def test_it_returns_an_array_of_all_invoice_instances
    assert_equal 2, @invoice.all.length
  end

  def test_it_can_return_an_invoice_by_invoice_id
    invoice_instance = @invoice.find_by_id(9)
    assert_equal :shipped ,invoice_instance.status
  end

  def test_it_will_return_nil_if_invoice_item_does_not_exist
    assert_equal nil, @invoice.find_by_id(124)
  end

  def test_it_can_return_an_array_of_invoices_by_customer_id
    invoice_instance = @invoice.find_all_by_customer_id(38)
    assert_equal :shipped ,invoice_instance[0].status
  end

  def test_it_will_return_an_empty_array_if_customer_id_doesnt_exist
    assert_equal [], @invoice.find_all_by_customer_id(124)
  end

  def test_it_can_return_an_array_of_invoices_by_merchant_id
    invoice_instance = @invoice.find_all_by_merchant_id(93)
    assert_equal :shipped ,invoice_instance[0].status
  end

  def test_it_will_return_an_empty_array_if_merchant_id_doesnt_exist
    assert_equal [], @invoice.find_all_by_merchant_id(124)
  end

  def test_it_will_find_all_by_status
    new_invoice = @invoice.find_all_by_status(:pending)
    assert_equal 6, new_invoice[0].id
  end

  def test_it_will_find_merchant_by_invoice
    merchant = inv.find_merchant_by_invoice_merch_id(12334105)
    assert_equal Merchant, merchant.class
    assert_equal "Shopin1901", merchant.name
  end

  def test_it_will_find_invoice_items_by_invoice
    invoice_items = inv.find_invoice_items_by_invoice_id(1)
    assert_equal Array, invoice_items.class
    assert_equal InvoiceItem, invoice_items[0].class
    assert_equal 1, invoice_items[0].id
  end

  def test_it_will_find_customer_by_invoice_id
    customer = inv.find_customer_by_invoice_customer_id(1)
    assert_equal Customer, customer.class
    assert_equal 1, customer.id
  end

  def test_it_will_find_transactions_by_invoice
    transaction = inv.find_transactions_by_invoice_id(1)
    assert_equal Array, transaction.class
    assert_equal Transaction, transaction[0].class
    assert_equal 2650, transaction[0].id
  end

  def test_it_will_find_items_by_invoice
    items = inv.find_items_by_invoice_id(263395237)
    assert_equal Item, items.class
    assert_equal 263395237,items.id
  end

end
