class ReportGenerator
  require 'csv'

  def initialize
    @start_time = DateTime.now.beginning_of_day - 1.days
    @end_time   = DateTime.now.beginning_of_day
    @text_date  = @start_time.strftime("%A %b %d")
    @file_name  = @start_time.strftime("power_up_%m_%d_%Y.csv")
    @data = data
  end

  def write_csv
    CSV.open("lib/csvs/#{@file_name}", "wb") do |csv|
      csv << data.keys
      csv << data.values
    end
  end

  def mail_csv
    ReportMailer.report_email(@text_date, @file_name).deliver_now
  end
  private

  def data
    daily_rentals = Rental.where(created_at: @start_time..@end_time)

    { total_rentals: daily_rentals.count, # Total # of rentals for the day
      unique_rentals: daily_rentals.select(:last_name, :phone_number).distinct.length, # Unique # of rentals for the day
      tablet_rentals: daily_rentals.includes(:locker).where(lockers: {large: true}).count,
      phone_rentals: daily_rentals.includes(:locker).where(lockers: {large: false}).count,
      unclaimed_eod: daily_rentals.current.count,
      average_length: calculate_length(daily_rentals.completed)}
  end

  def calculate_length(rentals)
    if rentals.length > 0
      lengths = rentals.map(&:rental_length)
      seconds = lengths.sum / lengths.size
      humanize_seconds(seconds)
    else
      "0"
    end

  end


  def humanize_seconds(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}(s)"
      end
    }.compact.reverse.join(' ')
  end
end
