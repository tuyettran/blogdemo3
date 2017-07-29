class UserMailer < ApplicationMailer
  def comment_notify comment
    @comment = comment
    mail to: @comment.post.user.email, subject: t("user_mailer.notification")
  end
end
