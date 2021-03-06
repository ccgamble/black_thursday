require 'pry'

class Invoice
  attr_reader :id, :customer_id, :merchant_id, :created_at, :updated_at,
              :invoice_repo

  def initialize(column, parent = nil)
    @id = column[:id].to_i
    @customer_id = column[:customer_id].to_i
    @merchant_id = column[:merchant_id].to_i
    @status = column[:status]
    @created_at = Time.parse(column[:created_at])
    @updated_at = Time.parse(column[:updated_at])
    @invoice_repo = parent
  end

  def status
    @status.to_sym
  end

  def merchant
    @invoice_repo.find_merchant_by_invoice_merch_id(self.merchant_id)
  end

  def day_of_the_week
    created_at.strftime("%w")
  end

  def items
    invoice_item_array = invoice_items
    invoice_item_array.map do |invoice_item|
      invoice_repo.find_items_by_invoice_id(invoice_item.item_id)
    end
  end

  def invoice_items
    invoice_repo.find_invoice_items_by_invoice_id(self.id)
  end

  def customer
    invoice_repo.find_customer_by_invoice_customer_id(self.customer_id)
  end

  def transactions
    invoice_repo.find_transactions_by_invoice_id(self.id)
  end

  def is_paid_in_full?
    transaction_array = transactions
    transaction_array.any? do |transaction|
      transaction.result == "success"
    end
  end

  def total
    if is_paid_in_full?
      invoice_item_array = invoice_items
      total = 0
      invoice_item_array.each do |item|
        price = item.unit_price
        num = item.quantity
        total += (num * price)
      end
    end
    total
  end

end
