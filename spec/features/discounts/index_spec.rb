require 'rails_helper'

RSpec.describe 'merchant_discounts index' do
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

    visit merchant_discounts_path(@merchant_1.id)
  end

  describe 'I navigate to the merchant_discounts index page' do
    it "I see all of my bulk discounts including their
      percentage discount and quantity thresholds
      And each bulk discount listed includes a link to its show page" do

      within("#bulk_discounts-#{@discount_1.id}") do
        expect(page).to have_link("View your Discounts")
        expect(page).to have_content("Right now, with discounts id: #{@discount_1.id}, you can receive a 1.0% percent discount, on quantities of 1 or more!")
      end

      within("#bulk_discounts-#{@discount_2.id}") do
        expect(page).to have_link("View your Discounts")
        expect(page).to have_content("Right now, with discounts id: #{@discount_2.id}, you can receive a 10.0% percent discount, on quantities of 5 or more!")
      end
    end
    it "I see a section with a header of Upcoming Holidays
      In this section the name and date of the next 3 upcoming
      US holidays are listed." do

        # Use the Next Public Holidays Endpoint in the
        #[Nager.Date API](https://date.nager.at/swagger/index.html)

      within(".row") do
        expect(page).to have_content("Upcoming Holidays!")
        expect(page).to have_content("Next 3 Upcoming Holidays")
        expect("Memorial Day").to appear_before("Independence Day")
        expect("2021-05-31").to appear_before("2021-07-05")
        expect("Independence Day").to appear_before("Labour Day")
        expect("2021-07-05").to appear_before("2021-09-06")
      end
    end
    it " I see a link to create a new discount When I click this link
      Then I am taken to a page to create a new discount" do

      within("#create_new_discount") do
        expect(page).to have_link("Create New Discount!")
        click_link("Create New Discount!")
      end
      expect(current_path).to eq(new_merchant_discount_path(@merchant_1.id))
    end
    it "Next to to each bulk discount I see a link to delete itself
      When I click this link Then I am redirected back to the bulk
      discounts index page And I no longer see the discount listed" do

      within("#bulk_discounts-#{@discount_1.id}") do
        expect(page).to have_button("Delete this Discount!")
        click_button("Delete this Discount!")
      end

      expect(current_path).to eq(merchant_discounts_path(@merchant_1.id))

      expect(page).to_not have_content(1.0)
      expect(page).to_not have_content("1 or more!")
    end
    it 'should display next three holidays' do
      expect(page).to have_content('Memorial Day')
      expect(page).to have_content('Independence Day')
      expect(page).to have_content('Labour Day')
    end
  end
end
