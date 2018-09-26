class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || value =~ PASSWORD_REGEXP
    record.errors.add(attribute, PASSWORD_ERROR)
  end
end
