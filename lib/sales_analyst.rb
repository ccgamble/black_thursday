require_relative 'sales_engine'
require 'pry'
require 'bigdecimal'
require 'date'

class SalesAnalyst
  def initialize(sales_engine)
    sales_engine = sales_engine
    @mr = sales_engine.merchants
    @items_per_merchant = []
    @merchant_array = @mr.merchant_array
    @ir = sales_engine.items.item_repository
    @item_repository = sales_engine.items
    @invoices_per_merchant = []
    @invr = sales_engine.invoices.invoice_repository
  end

  def find_items_per_merchant_array
    @items_per_merchant = @merchant_array.map do |merch|
      item_array = merch.items
      item_array.length
    end
  end

  def average_items_per_merchant
    items_array = find_items_per_merchant_array
    calculate_the_average(items_array).to_f
  end

  def calculate_the_average(array)
    array_length = BigDecimal(array.length)
    total = BigDecimal(array.reduce(:+))
    BigDecimal(sprintf("%.02f",(total/array_length)))
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant_array = find_items_per_merchant_array
    average = calculate_the_average(items_per_merchant_array)
    calculate_std_deviation(items_per_merchant_array, average)
  end

  def calculate_std_deviation(array, array_avg)
    std_dev_a = array.map {|num| (num.to_f - array_avg)**2}
    std_dev = Math.sqrt((std_dev_a.reduce(:+))/((std_dev_a.length)-1))
    sprintf("%.02f", std_dev).to_f
  end

  def merchants_with_high_item_count
    avg = average_items_per_merchant
    stdev = average_items_per_merchant_standard_deviation
    item_count = avg + stdev
    merchants_highest_count_items(item_count)
  end

  def merchants_highest_count_items(item_count)
    @merchant_array.find_all do |merchant|
      merchant.items.count > item_count
    end
  end

  def average_item_price_for_merchant(merchant_id)
    array_of_items = @mr.find_by_id(merchant_id).items
    item_prices = array_of_items.map do |item|
      item.unit_price
    end
    calculate_the_average(item_prices)
  end

  def average_average_price_per_merchant
    avg_price = @merchant_array.map do |merch|
      average_item_price_for_merchant(merch.id)
    end
    calculate_the_average(avg_price)
  end

  def golden_items
    golden_price = find_golden_item_price
    @ir.find_all do |item|
      item.unit_price > golden_price
    end
  end

  def find_price_array
    price_array = @ir.map {|item| item.unit_price}
  end

  def find_golden_item_price
    average = calculate_the_average(find_price_array)
    std_dev = calculate_std_deviation(find_price_array, average)
    golden_price = average + ( 2 * std_dev)
  end

  def average_invoices_per_merchant
    invoice_array = find_invoice_per_merchant_array
    avg = calculate_the_average(invoice_array).to_f
  end

  def find_invoice_per_merchant_array
    @invoices_per_merchant = @merchant_array.map do |merch|
      invoice_array = merch.invoices
      invoice_array.length
    end
  end

  def average_invoices_per_merchant_standard_deviation
    avg = average_invoices_per_merchant
    std_dev = calculate_std_deviation(find_invoice_per_merchant_array, avg)
  end

  def top_merchants_by_invoice_count
    avg = average_invoices_per_merchant
    std_dev = average_invoices_per_merchant_standard_deviation
    high_num = avg + 2* std_dev
    @merchant_array.find_all do |merchant|
      merchant.invoices.count > high_num
    end
  end

  def bottom_merchants_by_invoice_count
    avg = average_invoices_per_merchant
    std_dev = average_invoices_per_merchant_standard_deviation
    low_num = avg - 2* std_dev
    @merchant_array.find_all do |merchant|
      merchant.invoices.count < low_num
    end
  end

  def create_weekday_array
    wkday = Array.new(7) {|i| i = 0}
    @invr.each do |invoice|
      index = invoice.day_of_the_week.to_i
      wkday[index] += 1
    end
    wkday
  end

  def top_days_by_invoice_count
    array = create_weekday_array
    avg = calculate_the_average(array)
    std_dev = calculate_std_deviation(array, avg)
    highest_days = array.find_all do |count|
      count > (avg + std_dev)
    end
    result = highest_days.map {|num| array.index(num)}
    format_days_of_the_week(result)
  end

  def format_days_of_the_week(highest_days)
    day = Proc.new { |d| Date::DAYNAMES[d] }
    days = highest_days.map do |high_day|
      day.call(high_day)
    end
    days
  end

  def invoice_status(status)
    result = @invr.find_all {|invoice| invoice.status == status}
    percent = (result.count).to_f/(@invr.count) * 100
    sprintf("%.02f", percent).to_f
  end

  def total_revenue_by_date(date)
    total_revenue_for_date = 0
    invoices = @invr.find_all {|invoice| invoice.created_at == date}
    invoices.each do |invoice|
      (total_revenue_for_date += invoice.total) if invoice.is_paid_in_full?
    end
    total_revenue_for_date
  end

  def revenue_by_merchant(id)
    merchant = @mr.find_by_id(id)
    invoice_array = merchant.invoices
    total_revenue = 0
    invoice_array.each do |invoice|
      (total_revenue += invoice.total) if invoice.is_paid_in_full?
    end
    total_revenue
  end

  def top_revenue_earners(num = 20)
    merch_by_revenue = {}
    @merchant_array.each do |merchant|
      revenue = revenue_by_merchant(merchant.id)
      merch_by_revenue[merchant] = revenue
    end
    merch_revenue = merch_by_revenue.sort_by {|key, value| value}.reverse.to_h
    merch_revenue.keys.take(num)
  end

  def merchants_ranked_by_revenue
    num = @merchant_array.length
    top_revenue_earners(num)
  end

  def merchants_with_pending_invoices
    merchants = []
    @merchant_array.each do |merchant|
      invoice_array = merchant.invoices
      if invoice_array.any? {|invoice| invoice.is_paid_in_full? == false}
        merchants << merchant
      end
    end
    merchants
  end

  def merchants_with_only_one_item
    @merchant_array.find_all do |merch|
      merch.items.length == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merch_with_one_item = merchants_with_only_one_item
    registered_in_month = merch_with_one_item.find_all do |merchant|
      merchant.created_at.strftime("%B") == month
    end
  end

  def most_sold_item_for_merchant(merchant_id)
    merchant = @mr.find_by_id(merchant_id)
    successful = find_all_successful_invoices(merchant.invoices)
    ii_success = find_quantity_of_invoice_items(successful)
    quantity_array = get_quantity_of_invoice_items(ii_success)
    iq_hash = create_hash_by_item_id(quantity_array)
    iq_hash_sorted = iq_hash.sort_by {|key, value| key}.reverse.to_h
    item_ids = find_invoice_items_by_sorted_hash_keys(iq_hash_sorted)
    new_item_array = item_ids.uniq {|invoice_item| invoice_item.item_id}
    find_all_items_by_item_id(new_item_array)
  end

  def find_invoice_items_by_sorted_hash_keys(hash)
    hash.map do |key, value|
       key == (hash.keys[0]) ? value : nil
     end.compact.flatten
  end

  def find_all_successful_invoices(array)
    array.find_all do |invoice|
      invoice.is_paid_in_full?
    end
  end

  def find_quantity_of_invoice_items(array)
    successful_ii = array.map do |invoice|
      invoice.invoice_items
    end
    successful_ii.flatten
  end

  def get_quantity_of_invoice_items(invoice_items)
    array_to_be_grouped = []
    invoice_items.each do |invoice_item|
      num = invoice_item.quantity
      num.times do
        array_to_be_grouped << invoice_item
      end
    end
    array_to_be_grouped
  end

  def create_hash_by_item_id(array)
    array.group_by do |invoice_item|
      find_number_of_instances_of_an_id(array, invoice_item.item_id).length
    end
  end

  def find_number_of_instances_of_an_id(array, id)
    array.find_all do |invoice_instance|
      invoice_instance.item_id == id
    end
  end

  def find_all_items_by_item_id(item_ids)
    item_ids.map do |invoice_item|
      @item_repository.find_by_id(invoice_item.item_id)
    end
  end

  def best_item_for_merchant(merchant_id)
    merchant = @mr.find_by_id(merchant_id)
    successful = find_all_successful_invoices(merchant.invoices)
    ii_success = find_quantity_of_invoice_items(successful)
    quantity_array = get_quantity_of_invoice_items(ii_success)
    iq_hash = create_hash_by_revenue(quantity_array)
    iq_hash_sorted = iq_hash.sort_by {|key, value| key}.reverse.to_h
    item_ids = find_invoice_items_by_sorted_hash_keys(iq_hash_sorted)
    new_item_array = item_ids.uniq {|invoice_item| invoice_item.item_id}
    item = find_all_items_by_item_id(new_item_array)
    item[0]
  end

  def create_hash_by_revenue(array)
    array.group_by do |invoice_item|
      n = find_number_of_instances_of_an_id(array, invoice_item.item_id).length
      price = invoice_item.unit_price
      n * price
    end
  end



end
