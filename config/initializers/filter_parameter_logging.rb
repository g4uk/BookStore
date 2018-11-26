# frozen_string_literal: true

Rails.application.config.filter_parameters += %i[password cvv expiration_date owner_name number]
