require 'set'
require "../../Data/Contracts/StorageKeys"
require "../../Data/Contracts/ServerConfiguration"
require "../../Data/Contracts/ServerData"
require "../../Data/Contracts/AllServersData"
require "../../Common/Storage"
require "../../Common/ExecutableCommand"
require "../../Common/ErrorHandlingCommand"
require "../../Common/ExecutableCommandChainCreator"
require "../../Common/CommandProcessingQueue"
require "../../Messaging/Contracts/Constants"
require "../../Messaging/Contracts/BaseMessage"
require "../../Messaging/Contracts/ServerPingMessage"
require "../../Messaging/Contracts/MonitoringClientStartedMessage"
require "../../Messaging/Contracts/MonitoringClientConfigurationMessage"
require "./Internal/Storages/AllServersStorage"
require "./Internal/Contexts/MonitoringClientStartedContext"
require "./Internal/Commands/CreateOrUpdateServerIfNeededCommand"
require "./Internal/Commands/LoadServerConfigurationCommand"
require "./Internal/Commands/CreateClientConfigurationMessage"
require "./Internal/Commands/SendMqMessageCommand"
require "./Internal/CommandChainFactories/MonitoringCommandChainFactory"

class Server
  def initialize(mq_client, redis)
    @all_servers_storage = AllServersStorage.new(redis)
    @communication_queue = CommandProcessingQueue.new
    @chain_factory = MonitoringCommandChainFactory.new(mq_client, @all_servers_storage)
    @subscription_channel = create_subscriptions(mq_client)
  end

  public
  def start()
  end

  def stop()
    @subscription_channel.close()
    @communication_queue.dispose()
  end

  private
  def create_subscriptions(mq_client)
    ch = mq_client.create_channel
    ch.exchange_declare(EXCHANGE_MONITORING_SERVER_PING, "topic", opts = { :durable => true })
    ch.exchange_declare(EXCHANGE_MONITORING_COMMUNICATION, "topic", opts = { :durable => true })
    ch.exchange_declare(EXCHANGE_MONITORING_DATA, "topic", opts = { :durable => true })
    queue = ch.queue("CoreMonitoringServerCommunicationQueue", :durable => true)
    queue.bind(EXCHANGE_MONITORING_COMMUNICATION, opts = {:routing_key => MESSAGE_ID_MONITORING_CLIENT_STARTED})
    
    queue.subscribe do |delivery_info, metadata, payload|
      message = BaseMessage.deserialize(payload)
      case message.message_id
        when MESSAGE_ID_MONITORING_CLIENT_STARTED
          context = MonitoringClientStartedContext.new
          context.server_name = message.server_name
          context.ip_addresses = message.ip_addresses
          @communication_queue.enqueue(@chain_factory.client_started_chain(context))
      end
    end
    return ch
  end
end