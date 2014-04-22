require 'sinatra'
require 'sqlite3'
require 'json'

db = SQLite3::Database.new('./notifications.sqlite')
db.results_as_hash = true

get '/key/?' do
  routing_keys = {:keys => Array.new}

  db.execute("select distinct ROUTING_KEY from notifications") do |row|
    key = {:key => row['ROUTING_KEY']}
    key[:url] = "/key/#{row['ROUTING_KEY']}"
    routing_keys[:keys].push(key)
  end

  routing_keys.to_json  
end

get '/key/:id' do |tag|
  rows = Array.new
  db.execute("select * from notifications where ROUTING_KEY = ?", tag) do |row|
    row[:url] = "/notification/#{row["ID"]}"
    rows.push(row)
  end  
  rows.to_json
end

get '/notification/?' do
  rows = Array.new
  db.execute("select * from notifications") do |row|
    row[:url] = "/notification/#{row["ID"]}"
    rows.push(row)
  end

  rows.to_json
end

get '/notification/:id' do |id|
  db.execute("select * from notifications where ID = ?", id).to_json
end