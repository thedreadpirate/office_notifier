require 'ruby-growl'
require_relative('./queue_interface')

receiver = QueueInterface.new

puts ARGV

g = Growl.new "localhost", "Office Notifier"
g.add_notification("notification", "Office Notification")
receiver.subscribe(ARGV) do |delivery_info, properties, body|
  puts delivery_info
  g.notify('notification', "Office Notification", body)
end

