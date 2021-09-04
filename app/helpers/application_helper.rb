module ApplicationHelper
  def format_token_balance(val)
    precision = 100
    val = Ethereum::Formatter.new.from_wei(val).to_f.to_i
    val = (val * precision).round / precision
    val
  end
  
  def format_dapp_datetime(val)
    val.strftime("%I:%M:%S%P %d/%m")
  end
  
  def format_time(val)
    val.strftime("%l:%M:%S %P")
  end
  
  def format_decimals(number, places: 2)
    sprintf("%.#{places}f", number)
  end
  
  def buy_or_sell_color(val)
    val == "buy" ? 'text-success' : 'text-danger'
  end
  
  def bootstrap_class_for(flash_type)
      {
        success: "alert-success",
        error: "alert-danger",
        alert: "alert-warning",
        notice: "alert-info"
      }.stringify_keys[flash_type.to_s] || flash_type.to_s
    end
    
    def avatar_path(object, options = {})
        size = options[:size] || 180
        default_image = options[:default] || "mp"
        base_url =  "https://secure.gravatar.com/avatar"
        base_url_params = "?s=#{size}&d=#{default_image}"
    
        if object.respond_to?(:avatar) && object.avatar.attached? && object.avatar.variable?
          object.avatar.variant(resize_to_fill: [size, size, { gravity: 'Center' }])
        elsif object.respond_to?(:email) && object.email
          gravatar_id = Digest::MD5::hexdigest(object.email.downcase)
          "#{base_url}/#{gravatar_id}#{base_url_params}"
        else
          "#{base_url}/00000000000000000000000000000000#{base_url_params}"
        end
      end
end
