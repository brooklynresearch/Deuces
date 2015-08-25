class ReportMailer < ApplicationMailer

  RECIPIENTS = ["andrewglass1@gmail.com", "johnny@brooklynresearch.org", "ezer@brooklynresearch.org", "alex@brooklynresearch.org"]

  def report_email(date, file_name)
    @date = date
    attachments[file_name] = File.read("lib/csvs/#{file_name}")
    mail(to: RECIPIENTS, subject: "Power Up Usage Report - #{date}")
  end

end
