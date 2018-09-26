class CountriesListService
  class << self
    def call
      file = File.read("#{Rails.public_path}/countries.json")
      JSON.parse(file)
    end
  end
end
