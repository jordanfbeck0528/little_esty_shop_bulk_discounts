require 'rails_helper'

RSpec.describe 'merchant_discounts show' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @discount_1 = @merchant_1.discounts.create!(quantity: 1, percentage: 1)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)

    visit merchant_discount_path(@merchant_1.id, @discount_1.id)
  end

  describe 'I navigate to the merchant_discounts show page' do
    it "shows the bulk discount's quantity threshold and percentage discount,
      Then I see a link to edit the bulk discount, when I click this link,
      I am taken to a new page with a form to edit the discount" do

      within(".discount-info") do
        expect(page).to have_content(@discount_1.percentage)
        expect(page).to have_content(@discount_1.quantity)
        expect(page).to have_link("Edit this Discount")
        click_link("Edit this Discount")
      end
      expect(current_path).to eq(edit_merchant_discount_path(@merchant_1.id, @discount_1.id))
    end
  end
end
