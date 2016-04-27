require_relative 'test_helper'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'
require 'pry'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchant1, :merchant2, :merch

  def setup
    merchant1 = Merchant.new({:id => 12334105, :name => "Shopin1901"})
    merchant2 = Merchant.new({:id => 12334112, :name => "Candisart"})
    @merchant_repo = MerchantRepository.new
    @merchant_repo.merchant_array = ([merchant1, merchant2])

    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @merch = @se.merchants
  end

  def test_it_created_instance_of_merchant_repo_class
    assert_equal MerchantRepository, @merchant_repo.class
  end

  def test_it_inspects
    assert merch.inspect
  end

  def test_merchant_repo_starts_out_empty
    merchant_repo = MerchantRepository.new
    assert merchant_repo.merchant_array.empty?
  end

  def test_it_can_return_array_of_all_merchant_instances
    assert_equal Array, @merchant_repo.all.class
    assert_equal 2, @merchant_repo.all.length
  end

  def test_it_returns_merchant_by_finding_id
    assert_equal "Shopin1901", @merchant_repo.find_by_id(12334105).name
    assert_equal "Candisart", @merchant_repo.find_by_id(12334112).name
  end

  def test_it_returns_merchant_by_finding_name
    assert_equal 12334105, @merchant_repo.find_by_name("Shopin1901").id
    assert_equal 12334112, @merchant_repo.find_by_name("Candisart").id
  end

  def test_it_finds_all_instances_with_given_name_fragment
    merchant1 = Merchant.new({:id => 12334105, :name => "Shopin1901"})
    merchant2 = Merchant.new({:id => 12334112, :name => "Candisart"})
    merchant3 = Merchant.new({:id => 12345678, :name => "ShopsRUs"})
    merchant_repo = MerchantRepository.new
    merchant_repo.merchant_array = ([merchant1, merchant2, merchant3])
    output = merchant_repo.find_all_by_name("shop")

    assert_equal 2, output.length
  end

  def test_find_items_by_merch_id
    item_array = @merch.find_items_by_merchant_id(12334105)
    assert_equal Array, item_array.class
    assert_equal 3, item_array.length
  end

  def test_find_invoices_by_merch_id
    invoice_array = @merch.find_invoices_by_merchant_id(12334105)
    assert_equal Array, invoice_array.class
    assert_equal 10, invoice_array.length
  end

  def test_find_customer_by_invoice_customer_id
    customer = @merch.find_customer_by_invoice_customer_id(1)
    assert_equal Customer, customer.class
    assert_equal "Joey", customer.first_name
  end
end
