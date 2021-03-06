require 'time'

class Merchant
  attr_reader :id, :name, :merchant_repo

  def initialize(line_of_data, parent = nil)
    @id = line_of_data[:id].to_i
    @name = line_of_data[:name]
    @created_at = line_of_data[:created_at]
    @merchant_repo = parent
  end

  def items
    merchant_repo.find_items_by_merchant_id(id)
  end

  def invoices
    merchant_repo.find_invoices_by_merchant_id(id)
  end

  def created_at
    Time.parse(@created_at)
  end

  def customers
    invoice_customer_id = (invoices.map {|invoice| invoice.customer_id}).uniq
    invoice_customer_id.map do |id|
      merchant_repo.find_customer_by_invoice_customer_id(id)
    end
  end

end
