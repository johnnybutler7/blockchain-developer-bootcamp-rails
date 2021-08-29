module ApplicationHelper
  def format_token_balance(val)
    precision = 100
    val = Ethereum::Formatter.new.from_wei(val).to_f.to_i
    val = (val * precision).round / precision
    val
  end
  
  def format_datetime(val)
    val.strftime("%I:%M:%S%P %d/%m/%y")
  end
  
  def format_decimals(number, places: 2)
    sprintf("%.#{places}f", number)
  end
  
  def buy_or_sell_color(val)
    val == "buy" ? 'text-success' : 'text-danger'
  end
end
