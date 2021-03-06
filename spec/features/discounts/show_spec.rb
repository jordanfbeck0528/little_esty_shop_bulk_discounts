require 'rails_helper'

RSpec.describe 'merchant_discounts show' do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Hair Care')
    @discount_1 = @merchant_1.discounts.create!(quantity: 1, percentage: 1)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    visit merchant_discount_path(@merchant_1.id, @discount_1.id)
  end

  describe 'I navigate to the merchant_discounts show page' do
    it "shows the bulk discount's quantity threshold and percentage discount" do

      # require "pry"; binding.pry
      within(".discount-info") do
        expect(page).to have_content(@discount_1.percentage)
        expect(page).to have_content(@discount_1.quantity)
      end
    end
  end
end
