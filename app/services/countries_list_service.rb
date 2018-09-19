class CountriesListService
  class << self
    def call
      file = File.read("#{Rails.public_path}/countries.json")
      countries = JSON.parse(file)
      countries.collect { |country| [country['name'], country['dial_code']] }
    end
  end
end
