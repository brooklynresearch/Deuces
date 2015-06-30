module RentalsHelper

  def display_time_in(rental)
    rental.created_at.in_time_zone("EST").strftime("%B %e %l:%M %p") + " ( " + time_ago_in_words(rental.created_at) + " ago)"
  end

  def display_time_out(rental)
    rental.end_time.in_time_zone("EST").strftime("%B %e %l:%M %p") + " ( " + time_ago_in_words(rental.end_time) + " ago)"
  end
end
