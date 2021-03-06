require_relative 'test_helper'
require_relative '../lib/item'

class ItemTest < Minitest::Test

  def setup
    @i = Item.new({:id => 12345, :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(1099,4),
      :merchant_id => 98765,
      :created_at => Time.new.to_s, :updated_at => Time.new.to_s})
  end

  def test_it_created_instance_of_item_class
    assert_equal Item, @i.class
  end

  def test_it_returns_the_integer_id_of_the_item
    assert_equal 12345, @i.id
  end

  def test_it_returns_the_name_of_the_item
    assert_equal "Pencil", @i.name
  end

  def test_it_returns_the_description_of_the_item
    assert @i.description.include?("write")
  end

  def test_it_returns_price_of_item_formatted_as_big_decimal
    assert_equal 0.1099E2, @i.unit_price
  end

  def test_it_returns_created_time
    time = @i.created_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_returns_updated_time
    time = @i.updated_at
    current_time = Time.new
    assert_equal Time, time.class
    assert_equal current_time.year, time.year
  end

  def test_it_returns_merchant_id
    assert_equal 98765, @i.merchant_id
  end

  def test_it_can_return_unit_price_in_dollars
    assert_equal 10.99, @i.unit_price_to_dollars
  end

  def test_it_calls_its_parent_when_searching_for_merchants
    parent = Minitest::Mock.new
    i = Item.new({:id => 12345, :name => "Pencil",
      :description => "You can use it to write things",
      :unit_price => BigDecimal.new(1099,4),
      :merchant_id => 98765,
      :created_at => Time.new.to_s, :updated_at => Time.new.to_s}, parent)
    parent.expect(:find_merchant_by_merch_id, nil, [98765])
    i.merchant
    assert parent.verify
  end

end
