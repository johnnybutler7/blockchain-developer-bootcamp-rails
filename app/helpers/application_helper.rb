module ApplicationHelper
  def format_token_balance(val)
    precision = 100
    val = Ethereum::Formatter.new.from_wei(val).to_f.to_i
    val = (val * precision).round / precision
    val
  end
end
