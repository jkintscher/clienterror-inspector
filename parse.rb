#!/usr/bin/env ruby

require 'csv'
require 'json'

data = []
CSV.foreach('./ga.csv', 'r') do |json, event_data|
  if json and json[0] == '{'
    data.push JSON.parse(json)
  end
end

File.open('exceptions.json','w') do |f|
  f.write "var clienterror_exceptions=#{data.to_json()};"
end
