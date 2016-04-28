require 'csv'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'invoice_item_repository'
require_relative 'customer_repository'
require 'pry'

class SalesEngine
  attr_reader :merchant_contents, :item_contents, :invoice_contents,
              :invoice_item_contents, :transaction_contents, :customer_contents

  def initialize(m_file, it_file, inv_file, inv_it_file, t_file, c_file)
    @merchant_contents = open_csv(m_file)
    @item_contents = open_csv(it_file)
    @invoice_contents = open_csv(inv_file)
    @invoice_item_contents = open_csv(inv_it_file)
    @transaction_contents = open_csv(t_file)
    @customer_contents = open_csv(c_file)
    @items = ItemRepository.new(self)
    @merchants = MerchantRepository.new(self)
    @invoices = InvoiceRepository.new(self)
    @invoice_items = InvoiceItemRepository.new(self)
    @transactions = TransactionRepository.new(self)
    @customers = CustomerRepository.new(self)
    load_repositories
  end

  def self.from_csv(files_to_parse = {})
    item_file = files_to_parse.fetch(:items)
    m_file = files_to_parse.fetch(:merchants)
    invoice_file = files_to_parse.fetch(:invoices)
    ii_file = files_to_parse.fetch(:invoice_items)
    t_file = files_to_parse.fetch(:transactions)
    c_file = files_to_parse.fetch(:customers)
    SalesEngine.new(m_file, item_file, invoice_file, ii_file, t_file, c_file)
  end

  def open_csv(file)
    CSV.open file, headers: true, header_converters: :symbol
  end

  def load_repositories
    merchants
    items
    invoices
    invoice_items
    transactions
    customers
  end

  def items
    @items.item(item_contents)
  end

  def merchants
    @merchants.merchant_repo(merchant_contents)
  end

  def invoices
    @invoices.invoice(invoice_contents)
  end

  def invoice_items
    @invoice_items.invoice_item(invoice_item_contents)
  end

  def transactions
    @transactions.transaction(transaction_contents)
  end

  def customers
    @customers.customer(customer_contents)
  end

  def find_items_by_merch_id(merchant_id)
    @items.find_all_by_merchant_id(merchant_id)
  end

  def find_items_by_invoice_item_id(item_id)
    @items.find_by_id(item_id)
  end

  def find_merchant_by_merch_id(id)
    @merchants.find_by_id(id)
  end

  def find_invoices_by_merch_id(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_invoice_with_transaction_invoice_id(id)
    @invoices.find_by_id(id)
  end

  def find_customer_by_invoice_customer_id(customer_id)
    @invoices.find_all_by_customer_id(customer_id)
  end

  def find_invoice_items_with_invoice_id(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def find_customer_by_id(id)
    @customers.find_by_id(id)
  end

  def find_customers_by_id(customer_id)
    @customers.find_by_id(customer_id)
  end

  def find_transactions_by_invoice_id(invoice_id)
    @transactions.find_all_by_invoice_id(invoice_id)
  end

end
