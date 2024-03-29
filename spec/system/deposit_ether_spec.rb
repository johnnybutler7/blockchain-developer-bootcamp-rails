require "rails_helper"

RSpec.feature 'Deposit Ether', :type => :system do

  it "Enables me to deposit Ether" do
    deposit_eth_amount = 2
    
    visit root_path
    start_eth_amount = find('#deposit-exchange-ether-balance').text.to_f
    within('#ether-deposit-form') do
      fill_in 'ether_amount', with: deposit_eth_amount
      click_on 'Deposit'
    end

    within('.notices') do
      expect(page).to have_content('You successfuly deposited Ether')
    end
    within('#deposit-exchange-ether-balance') do
      expect(page).to have_content(start_eth_amount + deposit_eth_amount)
    end
  end
end