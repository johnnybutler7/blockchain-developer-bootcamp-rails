require "rails_helper"

RSpec.feature 'Deposit Ether', :type => :system do

  it "Enables me to deposit Ether" do
    deposit_eth_amount = 2
    
    visit accounts_path
    start_eth_amount = find('#exchange-ether-balance').text.to_f
    within('#deposit-ether-form') do
      fill_in 'ether_amount', with: deposit_eth_amount
      click_on 'Deposit'
    end

    within('#exchange-ether-balance') do
      expect(page).to have_content(start_eth_amount + deposit_eth_amount)
    end
  end
end