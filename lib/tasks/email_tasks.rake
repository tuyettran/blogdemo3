desc "month report"
task send_digest_email: :environment do
  UserMailer.month_report(8).deliver_now
end
