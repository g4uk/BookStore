# frozen_string_literal: true

NAME = /\A[a-zA-Z\s]+\Z/
ADDRESS = /\A[a-zA-Z0-9,\-\s]+\Z/
ZIP = /\A[0-9-]{1,10}\Z/
PHONE = /\A\+[0-9]{1,15}\Z/
CATEGORY = /\A[\w\s]+\Z/
COMMENT = %r/\A[a-zA-Z0-9\s\.!,;#$%&'*+\/=?^_`{\(|\)}~-]+\Z/
COUPON = /\A[A-Z0-9]{1,10}\Z/
CREDIT_CARD_NUMBER = /\A[0-9]+\Z/
EXPIRATION_DATE = %r/\A(0[1-9]|1[012])\/[0-9]{2}\Z/
PASSWORD_REGEXP = /\A(?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9])\S{8,}\z/
EMAIL_REGEXP = %r/\A([a-zA-Z0-9][!#$%&'*+\/\-=?^_`{|}~]?[\.]?){1,63}[a-zA-Z]{1,63}@[a-zA-Z0-9](?:[a-zA-Z0-9-]{1,63}[a-zA-Z0-9])?(?:\.[a-zA-Z]{1,63}?)*\z/
PASSWORD_ERROR = 'Complexity requirement not met. Length should be at least 8 characters and include: 1 uppercase, 1 lowercase, 1 digit character'
