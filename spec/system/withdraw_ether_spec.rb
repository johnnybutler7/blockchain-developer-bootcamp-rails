require "rails_helper"

RSpec.feature 'Withdraw Ether', :type => :system do

  it "Enables me to deposit Ether" do
    withdraw_eth_amount = 1
    
    visit accounts_path
    click_link 'Withdraw'
    start_eth_amount = find('#withdraw-exchange-ether-balance').text.to_f
    within('#ether-withdraw-form') do
      fill_in 'ether_amount', with: withdraw_eth_amount
      click_on 'Withdraw'
    end
    
    within('.notices') do
      expect(page).to have_content('Successfully withdrew Ether')
    end
    within('#withdraw-exchange-ether-balance') do
      expect(page).to have_content((start_eth_amount - withdraw_eth_amount).round(2))
    end
  end
end