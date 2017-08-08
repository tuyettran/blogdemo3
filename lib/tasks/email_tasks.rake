desc "month report"
task send_digest_email: :environment do
  UserMailer.month_report(Time.now).deliver_now
end
