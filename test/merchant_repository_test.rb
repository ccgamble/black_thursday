require_relative 'test_helper'
require_relative '../lib/merchant_repository'
require 'pry'

class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchant1, :merchant2

  def setup
    merchant1 = Merchant.new({:id => 12334105, :name => "Shopin1901"})
    merchant2 = Merchant.new({:id => 12334112, :name => "Candisart"})
    @merchant_repo = MerchantRepository.new
    @merchant_repo.merchant_array = ([merchant1, merchant2])
  end

  def test_it_created_instance_of_merchant_repo_class
    assert_equal MerchantRepository, @merchant_repo.class
  end

  def test_merchant_repo_loads_the_merchant_repository
    merchant_repo = MerchantRepository.new
    assert merchant_repo.merchant_array.empty?
    # assert_equal merchant_repo.merchant_array = ([merchant1, merchant2])
    # refute merchant_repo.merchant_array.empty?
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

  def test_find_customer_calls_its_parent
    parent = Minitest::Mock.new
    parent.expect(:find_customers_by_id, nil, [12334105])
    @merchant_repo.find_customer_by_invoice_customer_id()
    assert parent.verify
  end
end
