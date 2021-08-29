require "rails_helper"

RSpec.feature 'Fill Order', :type => :system do

  it "Enables me to fill a sell order" do
    visit accounts_path
    sell_order_id = ''
    
    within('#order-book') do
      sell_order_link = find(".sell-order", match: :first)
      sell_order_id = sell_order_link["data-order-id"] 
    
      sell_order_link.click
    end
    
    expect(page).to have_content('Order successfully filled')
    within('#my-trades') do
      expect(page).to have_selector(:css, "tr#my-trade-#{sell_order_id}")
    end
    within('#order-book') do
      expect(page).to_not have_selector(:css, "tr#sell-order-#{sell_order_id}")
    end
  end
  
  it "Enables me to fill a buy order" do
    visit accounts_path
    buy_order_id = ''
    
    within('#order-book') do
      buy_order_link = find(".buy-order", match: :first)
      buy_order_id = buy_order_link["data-order-id"] 
    
      buy_order_link.click
    end

    within('.notices') do
      expect(page).to have_content('Order successfully filled')
    end
    within('#my-trades-list') do
      expect(page).to have_selector(:css, "tr#my-trade-#{buy_order_id}")
    end
    within('#order-book') do
      expect(page).to_not have_selector(:css, "tr#buy-order-#{buy_order_id}")
    end
  end
end