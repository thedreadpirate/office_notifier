require 'mongo'
require_relative('./queue_interface')

client = Mongo::Connection.new
db = client['notifications_db']
coll = db['office_notifications']

receiver = QueueInterface.new

puts "Listening to topic: #{ARGV}"

receiver.subscribe(ARGV) do |delivery_info, properties, body|
  puts "inserting: #{body}"
  coll.insert(body)
end
