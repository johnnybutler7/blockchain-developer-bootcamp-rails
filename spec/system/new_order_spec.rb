require "rails_helper"

RSpec.feature 'New Order', :type => :system do

  it "Enables me to buy tokens" do
    visit root_path
    fill_in 'buy_amount', with: '245'
    fill_in 'buy_price', with: '0.0023'
    click_on 'Buy Order'
    
    within('.notices') do
      expect(page).to have_content('Buy order successfully placed')
    end
    within('#order-book') do
      expect(page).to have_content('245')
      expect(page).to have_content('0.0023')
    end
  end
end