require 'rails_helper'

RSpec.describe 'new merchant_discounts' do
  before :each do

    @merchant_1 = Merchant.create!(name: 'Hair Care')

    @discount_1 = @merchant_1.discounts.create!(quantity: 1, percentage: 1)
    @discount_2 = @merchant_1.discounts.create!(quantity: 5, percentage: 10)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant_1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant_1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction_2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction_3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction_4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction_5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction_6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction_7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    visit new_merchant_discount_path(@merchant_1.id)
  end
  describe 'I navigate to the merchant_discounts new page' do
    it "I see a form to add a new bulk discount, When I fill in the
      form with valid data, Then I am redirected back to the
      bulk discount index, And I see my new bulk discount listed" do

      @merchant_1.discounts.destroy_all

      expect(page).to have_field("Discount Percentage Threshhold Create:")
      expect(page).to have_field("Discount Quantity Threshhold Create:")

      x = "15.0"
      y = "12"

      fill_in "Discount Percentage Threshhold Create:", with: x
      fill_in "Discount Quantity Threshhold Create:", with: y

      click_button("Create This Discount")

      expect(current_path).to eq(merchant_discounts_path(@merchant_1.id))

      @merchant_1.discounts.each do |discount|
        within("#discount-#{discount.id}") do
          expect(page).to have_content(x)
          expect(page).to have_content(y)
          expect(page).to have_content(discount.id)
        end
      end
    end
    it "shows a flash message if not all sections are filled in" do
      visit new_merchant_discount_path(@merchant_1.id)

      fill_in "Discount Percentage Threshhold Create:", with: ""
      fill_in "Discount Quantity Threshhold Create:", with: "5"

      click_button "Create This Discount"

      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
      expect(page).to have_content("All fields must be completed, please try again.")
    end
  end
end
