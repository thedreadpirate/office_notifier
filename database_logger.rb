require 'mongo'
require 'json'
require_relative('./queue_interface')

client = Mongo::Connection.new
db = client.db('notifications_db')
coll = db.collection('office_notifications')

receiver = QueueInterface.new

puts "Listening to topic: #{ARGV}"

receiver.subscribe(ARGV) do |delivery_info, properties, body|
  puts "inserting: #{delivery_info}"
  coll.update({"_id" => delivery_info[:routing_key]}, {'$push' => { "notifications" => JSON.parse(body)}}, {:upsert => true})
end

puts "In db: #{coll.find}"