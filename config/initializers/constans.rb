# frozen_string_literal: true

NAME = /\A[a-zA-Z\s]+\Z/
ADDRESS = /\A[a-zA-Z0-9,\-\s]+\Z/
ZIP = /\A[0-9-]{1,10}\Z/
PHONE = /\A\+[0-9\s]{1,15}\Z/
CATEGORY = /\A[\w\s]+\Z/
COMMENT = %r/\A[a-zA-Z0-9\s\.!,;#$%&'*+\/=?^_`{\(|\)}~-]+{1,500}\Z/
COUPON = /\A[A-Z0-9]{1,10}\Z/
CREDIT_CARD_NUMBER = /\A[0-9]+\Z/
EXPIRATION_DATE = %r/\A(0[1-9]|1[012])\/[0-9]{2}\Z/
PASSWORD_REGEXP = /\A(?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])\S{8,}\z/
EMAIL_REGEXP = %r/\A([a-zA-Z0-9][!#$%&'*+\/\-=?^_`{|}~]?[\.]?){1,63}[a-zA-Z]{1,63}@[a-zA-Z0-9](?:[a-zA-Z0-9-]{1,63}[a-zA-Z0-9])?(?:\.[a-zA-Z]{1,63}?)*\z/

IMAGES_NUMBER_ERROR = 'Too much images. Only 4 allowed'
PASSWORD_ERROR = 'Should be min 8 letters, at list 1 uppercase, 1 lowercase, 1 number'

INPUT_VALIDATIONS = {
  name: '^[a-zA-Z\s]+$',
  phone: '^\+[0-9\s]{1,15}$',
  address: '^[a-zA-Z0-9,\-\s]+$',
  zip: '^[0-9-]{1,10}$',
  card_number: '^[0-9]+$',
  expiration_date: '^(0[1-9]|1[012])\/[0-9]{2}$',
  code: '^[A-Z0-9]{1,10}$',
  review: '^[a-zA-Z0-9\s\.!,;#$%&\'*+\/=?^_`{\(|\)}~-]{1,500}$',
  email: "^([a-zA-Z0-9][!#$%&'*+\/\-=?^_`{|}~]?[\.]?){1,63}[a-zA-Z]{1,63}@[a-zA-Z0-9](?:[a-zA-Z0-9-]{1,63}[a-zA-Z0-9])?(?:\.[a-zA-Z]{1,63}?)*$",
  password: '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})'
}.freeze
