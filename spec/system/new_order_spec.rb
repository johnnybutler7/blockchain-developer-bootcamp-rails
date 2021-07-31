require "rails_helper"

RSpec.feature 'New Order', :type => :system do

  it "Enables me to buy tokens" do
    visit accounts_path
    fill_in 'buy_amount', with: '100'
    fill_in 'buy_price', with: '0.001'
    click_on 'Buy Order'
    
    expect(page).to have_content('Order successfully placed')
  end
end