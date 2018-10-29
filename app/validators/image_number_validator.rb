class ImageNumberValidator < ActiveModel::EachValidator
  IMAGES_NUMBER_ERROR = 'Too much images. Only 4 allowed'.freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, IMAGES_NUMBER_ERROR) if value.size > 4
  end
end
