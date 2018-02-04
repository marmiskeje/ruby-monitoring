require 'thread'
require "redis"
require 'concurrent'
require "bunny"

require "./Internal/Server"

mq_client = Bunny.new
mq_client.start
redis = Redis.new
Server.new(mq_client, redis)

gets()
mq_client.stop
redis.close

#redis.set("test", "hodnota", {:ex => 10})
# queue = CommandProcessingQueue.new

# class Test
#   def execute()
#     print("test")
#   end
# end
# queue.enqueue(Test.new)
# queue.enqueue(Test.new)
# sleep 300
# queue.dispose()

# redis = Redis.new
# redis.config 'SET', 'notify-keyspace-events', 'KEA'
# thread = Thread.new {
# redis.psubscribe("__keyspace*__:*") do |on|
#   on.psubscribe do |channel, subscriptions|
#     puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
#   end

#   on.pmessage do |pattern, channel, message|
#     puts "#{pattern}__#{channel}__#{message}"
#     redis.unsubscribe if message == "exit"
#   end

#   on.punsubscribe do |channel, subscriptions|
#     puts "Unsubscribed from ##{channel} (#{subscriptions} subscriptions)"
#   end
# end
# }
# gets()
# puts "odosielam"
# begin
#   redis2 = Redis.new
#   #redis2.config 'SET', 'notify-keyspace-events', 'KEA'
#   redis2.set("test", "hodnota", {:ex => 10})
#   redis2.set("test", "hodnota", {:ex => 10})
#   puts(redis2.get("test"))
#   #redis2.publish("__keyevent@0__:expired", "Test")
# rescue Exception => e
#   puts(e.message)
# end
# puts "odoslane"
# gets()