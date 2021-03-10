class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def applicable_discount

    discounts.where("#{self.quantity} >= quantity")
  end

  def top_applicable_discount
    applicable_discount.order(percentage: :desc).limit(1).pluck(:id).first
  end
end
