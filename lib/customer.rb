class Customer
  attr_reader :id, :first_name, :last_name, :created_at, :updated_at,
              :customer_repository

  def initialize(column, parent = nil)
    @id = column[:id].to_i
    @first_name = column[:first_name]
    @last_name = column[:last_name]
    @created_at = Time.parse(column[:created_at])
    @updated_at = Time.parse(column[:updated_at])
    @customer_repository = parent
  end

  def merchants
    invoice_array = customer_repository.find_invoices_by_customer_id(self.id)
    invoice_array.map do |invoice|
      id = invoice.merchant_id
      customer_repository.find_merchants_by_invoice_merchant_id(id)
    end
  end

end
