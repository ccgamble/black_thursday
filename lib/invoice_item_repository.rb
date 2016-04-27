require_relative 'invoice_item'
require 'pry'

class InvoiceItemRepository
  attr_accessor :invoice_item_repository

  def initialize(parent = nil)
    @se = parent
    @invoice_item_repository = []
  end

  def inspect
  "#<#{self.class} #{@invoice_items.size} rows>"
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
    invoice_item_repository.find {|invoice_item| invoice_item.id == find_id }
  end

  def find_all_by_item_id(item_id)
    invoice_item_repository.find_all {|invoice_item| invoice_item.item_id == item_id }
  end

  def find_all_by_invoice_id(find_id)
    invoice_item_repository.find_all {|invoice_item| invoice_item.invoice_id == find_id }
  end

  # def find_total_quantity_by_item_id(id)
  #   all_invoice_item_instances = find_all_by_item_id(id)
  #   total = 0
  #   all_invoice_item_instances.each {|invoice_item| total += invoice_item.quantity}
  #   total
  # end

end
