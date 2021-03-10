require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant_1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
  end
  it "#apply_discounts example 3" do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Dog Stuff')
    @merchant_3 = Merchant.create!(name: 'Cat Stuff')

    @discount_1 = Discount.create(merchant_id: @merchant_1.id, quantity: 10, percentage: 20)
    @discount_2 = Discount.create(merchant_id: @merchant_1.id, quantity: 15, percentage: 30)
    @discount_3 = Discount.create(merchant_id: @merchant_2.id, quantity: 15, percentage: 30)
    @discount_4 = Discount.create(merchant_id: @merchant_3.id, quantity: 15, percentage: 30)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
    @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Bone", description: "its a bone", unit_price: 4, merchant_id: @merchant_2.id)
    @item_4 = Item.create!(name: "Catnip", description: "its catnip", unit_price: 3, merchant_id: @merchant_3.id)

    @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 12, unit_price: 100, status: 2)
    @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)
    @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)
    @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)

    expect(@invoice_1.total_revenue).to eq(5700)
    expect(@invoice_1.total_revenue_lost_to_discounts).to eq(1590)
    expect(@invoice_1.total_revenue - @invoice_1.total_revenue_lost_to_discounts).to eq(4110)
  end
  it "#apply_discounts example 3" do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @merchant_2 = Merchant.create!(name: 'Dog Stuff')
    @merchant_3 = Merchant.create!(name: 'Cat Stuff')

    @discount_1 = Discount.create(merchant_id: @merchant_1.id, quantity: 10, percentage: 20)
    @discount_2 = Discount.create(merchant_id: @merchant_1.id, quantity: 15, percentage: 30)
    @discount_3 = Discount.create(merchant_id: @merchant_2.id, quantity: 15, percentage: 30)
    @discount_4 = Discount.create(merchant_id: @merchant_3.id, quantity: 15, percentage: 30)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
    @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Bone", description: "its a bone", unit_price: 4, merchant_id: @merchant_2.id)
    @item_4 = Item.create!(name: "Catnip", description: "its catnip", unit_price: 3, merchant_id: @merchant_3.id)

    @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 12, unit_price: 100, status: 2)
    @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)
    @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)
    @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 15, unit_price: 100, status: 1)

    expect(@invoice_1.total_revenue).to eq(5700)
    expect(@invoice_1.total_revenue_lost_to_discounts).to eq(1590)
    expect(@invoice_1.total_revenue - @invoice_1.total_revenue_lost_to_discounts).to eq(4110)
  end
end
