module ApplicationHelper

  def page_title
    if [Admin::LockersController, Admin::RentalsController].include?(controller.class)
      "Admin"
    else
      "PowerUp"
    end
  end
end
