# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentDecorator do
  let(:user) { create(:user) }
  let(:comment) { create(:comment).decorate }

  it 'formats date' do
    date = comment.created_at.strftime('%m/%d/%y')
    expect(comment.formatted_date).to eql(date)
  end

  it 'gets email_first_letter' do
    email_first_letter = comment.user.email.slice(0, comment.user.email.index('@'))
    expect(comment.email_first_letter).to eql(email_first_letter)
  end
end
