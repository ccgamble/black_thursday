require_relative 'invoice_item'
require 'pry'

class InvoiceItemRepository
  attr_accessor :invoice_item_repository

  def initialize(parent = nil)
    @se = parent
    @invoice_item_repository = []
  end

  def inspect
  "#<#{self.class} #{@invoice_item_repository.size} rows>"
  end

  def invoice_item(contents)
    contents.each do |column|
      @invoice_item_repository << InvoiceItem.new(column, self)
    end
    self
  end

  def all
    invoice_item_repository.empty? ?  nil : invoice_item_repository
  end

  def find_by_id(find_id)
    invoice_item_repository.find {|inv_item| inv_item.id == find_id }
  end

  def find_all_by_item_id(item_id)
    invoice_item_repository.find_all {|inv_item| inv_item.item_id == item_id }
  end

  def find_all_by_invoice_id(id)
    invoice_item_repository.find_all {|inv_item| inv_item.invoice_id == id}
  end

end
