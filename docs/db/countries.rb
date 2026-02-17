require "net/http"
require "json"
require "yaml"

json = Net::HTTP.get(URI("https://restcountries.com/v3.1/all?fields=name,population,capital,region,unMember,maps,independent"))
data = JSON.parse(json)

yaml = data.map do |country|
  next unless country["independent"]

  {
    "name" => country["name"]["common"],
    "capital" => country["capital"][0],
    "population" => country["population"],
    "region" => country["region"],
    "un_member" => country["unMember"],
    "openstreetmap" => country["maps"]["openStreetMaps"],
  }
end

yaml.compact!
yaml.sort_by! { |country| country["name"] }
File.write("countries.yml", yaml.to_yaml)
