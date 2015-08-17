module ApplicationHelper

  def page_title
    if [Admin::LockersController, Admin::RentalsController].include?(controller.class)
      "Admin"
    else
      "PowerUp"
    end
  end

  def device_id_class
    if params["device_id"] == "0"
      "zero"
    elsif params["device_id"] == "1"
      "one"
    elsif params["device_id"] == "2"
      "two"
    else
      "zero"
    end


  end
end
