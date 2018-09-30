class CommentDecorator < Draper::Decorator
  delegate_all

  def formatted_date
    created_at.strftime('%m/%d/%y')
  end

  def email_first_letter
    user.email.slice(0, user.email.index('@'))
  end

  def verified_reviewer
    I18n.t(:verified_reviewer) if user.orders.paid.size.positive?
  end
end
