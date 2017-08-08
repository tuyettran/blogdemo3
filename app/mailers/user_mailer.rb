class UserMailer < ApplicationMailer
  def comment_notify comment
    @comment = comment
    mail to: @comment.post.user.email, subject: "Web blog notification"
  end

  def month_report month
    mail to: "tran.thi.anh.tuyet@framgia.com", subject: "Month report"
  end
end
