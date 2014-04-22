require 'sinatra'
require 'json'
require_relative './queue_interface'

notifications = Array.new
publisher = QueueInterface.new

notifications.push({message: 'a value', from: 'test', date: Time.new.inspect})

get '/' do
  erb :index
end

get '/notification' do
  return notifications.to_json
end

post '/notification' do
  message = JSON.parse(request.body.read)
  puts message
  notifications.push(message)
  publisher.publish(message.to_json, "all")
end

