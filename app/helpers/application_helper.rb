module ApplicationHelper
  def format_time(val)
    val.strftime("%l:%M:%S %P")
  end
  
  def format_decimals(number, places: 2)
    sprintf("%.#{places}f", number)
  end

  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
