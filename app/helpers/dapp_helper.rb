module DappHelper
  def format_token_balance(val)
    precision = 100
    val = Ethereum::Formatter.new.from_wei(val).to_f.to_i
    val = (val * precision).round / precision
    val
  end
  
  def format_dapp_datetime(val)
    val.strftime("%l:%M:%S%P %e/%-m")
  end

  def buy_or_sell_color(val)
    val == "buy" ? 'text-success' : 'text-danger'
  end

  def price_symbol(last_price_change)
    if last_price_change == '+'
      content_tag :span, '&#9650;'.html_safe, class: 'text-success'
    else
      content_tag :span, '&#9660;'.html_safe,  class: 'text-danger'
    end
  end
end