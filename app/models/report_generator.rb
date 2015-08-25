class ReportGenerator
  require 'csv'

  def initialize
    @start_time = Date.yesterday.beginning_of_day
    @end_time   = Date.yesterday.end_of_day
    @file_name  = Date.yesterday.strftime("power_up_%m_%d_%Y.csv")
    @data = data
  end

  def write_csv
    CSV.open("lib/csvs/#{@file_name}", "wb") do |csv|
      csv << data.keys
      csv << data.values
    end
  end

  def data
    daily_rentals = Rental.where(created_at: @start_time..@end_time)

    { total_rentals: daily_rentals.count, # Total # of rentals for the day
      unique_rentals: daily_rentals.select(:last_name, :phone_number).distinct.length, # Unique # of rentals for the day
      tablet_rentals: daily_rentals.includes(:locker).where(lockers: {large: true}).count,
      phone_rentals: daily_rentals.includes(:locker).where(lockers: {large: false}).count,
      unclaimed_eod: daily_rentals.current.count,
      average_length: calculate_length(daily_rentals.completed)}
  end


private

  def calculate_length(rentals)
    lengths = rentals.map(&:rental_length)
    lengths.sum / lengths.size
  end

end
