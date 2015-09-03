class ReportMailer < ApplicationMailer

  RECIPIENTS = ["andrewglass1@gmail.com", "johnny@brooklynresearch.org", "ezer@brooklynresearch.org", "alex@brooklynresearch.org", "gmarkant@thisismkg.com", "irodriguez@thisismkg.com"]

  def report_email(date, file_name)
    @date = date
    attachments[file_name] = File.read("lib/csvs/#{file_name}")
    mail(to: RECIPIENTS, subject: "Power Up Usage Report - #{date}")
  end

end
