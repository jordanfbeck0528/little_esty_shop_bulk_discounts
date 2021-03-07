require 'rails_helper'

RSpec.describe 'merchant_discounts edit' do
  # before :each do
  #   @merchant_1 = Merchant.create!(name: 'Hair Care')
  #   @discount_1 = @merchant_1.discounts.create!(quantity: 1, percentage: 1)
  #   @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
  #
  #   visit edit_merchant_discount_path(@merchant_1.id, @discount_1.id)
  # end

  describe 'As a visitor when i navigate to the merchant discount edit page' do
    it "I see that the discounts current attributes are pre-populated in the form
    When I change any/all of the information and click submit,
    Then I am redirected to the bulk discount's show page,
    And I see that the discount's attributes have been updated" do

      @merchant_1 = Merchant.create!(name: 'Hair Care')
      @discount_1 = @merchant_1.discounts.create!(quantity: 1, percentage: 1)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      visit edit_merchant_discount_path(@merchant_1.id, @discount_1.id)

      within(".edit-discount-info") do
        expect(page).to have_field("Discount Percentage Threshhold:")
        expect(page).to have_field("Discount Quantity Threshhold:")
        fill_in "Discount Percentage Threshhold:", with: 20.0
        fill_in "Discount Quantity Threshhold:", with: 15
        click_button("Edit This Discount")
      end

      expect(current_path).to eq(merchant_discount_path(@merchant_1.id, @discount_1.id))

      @merchant_1.discounts.each do |discount|
        within("#discount-info") do
          expect(page).to have_content(20.0)
          expect(page).to have_content(15)
          expect(page).to have_content(discount.id)
        end
      end
    end
  end
end
