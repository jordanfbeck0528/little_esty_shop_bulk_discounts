require 'rails_helper'

describe 'Admin Merchant Show' do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
    visit admin_merchant_path(@m1)
  end

  it 'should have merchant name' do
    expect(page).to have_content(@m1.name)
  end

  it 'should have a link to update merchant' do
    expect(page).to have_link('Update Merchant')

    click_link 'Update Merchant'

    expect(current_path).to eq(edit_admin_merchant_path(@m1))
  end

  it 'should display updated information' do
    visit edit_admin_merchant_path(@m1)

    fill_in 'merchant[name]', with: 'Dang Boiii'

    click_button

    expect(current_path).to eq(admin_merchant_path(@m1))
    expect(page).to have_content('Dang Boiii')
  end
end
# it 'should have status as a select field that updates the invoices status' do
#   within("#status-update-#{@i1.id}") do
#     select('cancelled', :from => 'invoice[status]')
#     expect(page).to have_button('Update Invoice')
#     click_button 'Update Invoice'
#
#     expect(current_path).to eq(admin_invoice_path(@i1))
#     expect(@i1.status).to eq('complete')
#   end
# end 
