class ImageNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, IMAGES_NUMBER_ERROR) if value.size > 4
  end
end
