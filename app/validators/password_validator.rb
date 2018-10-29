# frozen_string_literal: true

class PasswordValidator < ActiveModel::EachValidator
  PASSWORD_ERROR = 'Should be min 8 letters, at list 1 uppercase, 1 lowercase, 1 number'
  PASSWORD_REGEXP = /\A(?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])\S{8,}\z/

  def validate_each(record, attribute, value)
    return if value.blank? || value =~ PASSWORD_REGEXP
    record.errors.add(attribute, PASSWORD_ERROR)
  end
end
