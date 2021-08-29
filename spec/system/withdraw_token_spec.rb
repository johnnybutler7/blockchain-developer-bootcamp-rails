require "rails_helper"

RSpec.feature 'Withdraw Tokens', :type => :system do

  it "Enables me to deposit Tokens" do
    withdraw_token_amount = 100
    
    visit accounts_path
    click_link "Withdraw"
    start_token_amount = find('#withdraw-exchange-token-balance').text.to_i
    within('#token-withdraw-form') do
      fill_in 'token_amount', with: withdraw_token_amount
      click_on 'Withdraw'
    end
    
    within('.notices') do
      expect(page).to have_content('Successfully withdrew Tokens')
    end

    within('#withdraw-exchange-token-balance') do
      expect(page).to have_content((start_token_amount - withdraw_token_amount).to_i)
    end
  end
end