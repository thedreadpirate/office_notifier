require 'sinatra'
require 'sqlite3'
require 'json'
require_relative('../queue_interface')

receiver = QueueInterface.new

db = SQLite3::Database.new('./notifications.sqlite')

puts "Listening to topic(s): #{ARGV}"

receiver.subscribe(ARGV) do |delivery_info, properties, body|
 db.execute("insert into notifications(ROUTING_KEY, MESSAGE) values (?, ?)", 
     delivery_info[:routing_key], body);  
end

