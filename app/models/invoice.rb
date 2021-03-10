class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants
  has_many :discounts, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_lost_to_discounts
    invoice_items.joins(:discounts)
    .where('invoice_items.quantity >= discounts.quantity')
    .group('invoice_items.item_id')
    .select('invoice_items.item_id, MAX(invoice_items.quantity * invoice_items.unit_price * discounts.percentage * 0.01)')
    .sum(&:max)
  end

  def total_revenue_with_discounts
    total_revenue - total_revenue_lost_to_discounts
  end
end
