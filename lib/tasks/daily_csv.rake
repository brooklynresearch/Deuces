namespace :daily_csv do
  desc "Runs the daily csv report"
  task run: :environment do
    report_generator = ReportGenerator.new
    report_generator.write_csv
  end


end
