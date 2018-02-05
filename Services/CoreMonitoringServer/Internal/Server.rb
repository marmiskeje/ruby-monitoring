require 'set'
require "../../Data/Contracts/StorageKeys"
require "../../Data/Contracts/ServerConfiguration"
require "../../Data/Contracts/ServerData"
require "../../Data/Contracts/AllServersData"
require "../../Data/Contracts/ServicesData"
require "../../Data/Contracts/HddsData"
require "../../Data/Contracts/MonitoringProfiles"
require "../../Data/Contracts/HddConfiguration"
require "../../Data/Contracts/ServiceConfiguration"
require "../../Common/Storage"
require "../../Common/ExecutableCommand"
require "../../Common/ErrorHandlingCommand"
require "../../Common/ExecutableCommandChainCreator"
require "../../Common/CommandProcessingQueue"
require "../../Messaging/Contracts/Data/WatchedHddInfo"
require "../../Messaging/Contracts/Data/WatchedServiceInfo"
require "../../Messaging/Contracts/Constants"
require "../../Messaging/Contracts/BaseMessage"
require "../../Messaging/Contracts/ServerPingMessage"
require "../../Messaging/Contracts/MonitoringClientStartedMessage"
require "../../Messaging/Contracts/MonitoringClientConfigurationMessage"
require "../../Messaging/Contracts/ServicesChangedEventMessage"
require "../../Messaging/Contracts/HddsChangedEventMessage"
require "./Contracts/EmailDefinition"
require "./Internal/Storages/AllServersStorage"
require "./Internal/Storages/ServicesStorage"
require "./Internal/Storages/HddsStorage"
require "./Internal/Contexts/MonitoringClientStartedContext"
require "./Internal/Contexts/ServerPingContext"
require "./Internal/Contexts/ServicesChangedContext"
require "./Internal/Contexts/HddsChangedContext"
require "./Internal/Commands/CreateOrUpdateServerIfNeededCommand"
require "./Internal/Commands/LoadServerConfigurationCommand"
require "./Internal/Commands/CreateClientConfigurationMessage"
require "./Internal/Commands/SendMqMessageCommand"
require "./Internal/Commands/CreateOrUpdateServicesDataCommand"
require "./Internal/Commands/CreateOrUpdateHddsDataCommand"
require "./Internal/Commands/SendEmailsCommand"
require "./Internal/Commands/CreateServiceEmailsIfNeededCommand"
require "./Internal/Commands/CreateHddEmailsIfNeededCommand"
require "./Internal/CommandChainFactories/MonitoringCommandChainFactory"

class Server
  def initialize(mq_client, redis)
    @all_servers_storage = AllServersStorage.new(redis)
    @services_storage = ServicesStorage.new(redis)
    @hddsStorage = HddsStorage.new(redis)
    @communication_queue = CommandProcessingQueue.new
    @services_data_queue = CommandProcessingQueue.new
    @drives_data_queue = CommandProcessingQueue.new
    @chain_factory = MonitoringCommandChainFactory.new(mq_client, @all_servers_storage, @services_storage, @hddsStorage)
    @subscription_channel = create_subscriptions(mq_client)
  end

  public
  def start()
  end

  def stop()
    @subscription_channel.close()
    @communication_queue.dispose()
    @services_data_queue.dispose()
    @drives_data_queue.dispose()
  end

  private
  def create_subscriptions(mq_client)
    ch = mq_client.create_channel
    ch.exchange_declare(EXCHANGE_MONITORING_SERVER_PING, "topic", opts = { :durable => true })
    ch.exchange_declare(EXCHANGE_MONITORING_COMMUNICATION, "topic", opts = { :durable => true })
    ch.exchange_declare(EXCHANGE_MONITORING_DATA, "topic", opts = { :durable => true })
    queue = ch.queue("CoreMonitoringServerCommunicationQueue", :durable => true)
    queue.bind(EXCHANGE_MONITORING_COMMUNICATION, opts = {:routing_key => MESSAGE_ID_MONITORING_CLIENT_STARTED})
    queue.bind(EXCHANGE_MONITORING_SERVER_PING, opts = {:routing_key => MESSAGE_ID_SERVER_PING})
    queue.bind(EXCHANGE_MONITORING_DATA, opts = {:routing_key => MESSAGE_ID_SERVICES_CHANGED_EVENT})
    queue.bind(EXCHANGE_MONITORING_DATA, opts = {:routing_key => MESSAGE_ID_HDDS_CHANGED_EVENT})
    
    queue.subscribe do |delivery_info, metadata, payload|
      message = BaseMessage.deserialize(payload)
      case message.message_id
        when MESSAGE_ID_MONITORING_CLIENT_STARTED
          context = MonitoringClientStartedContext.new
          context.server_name = message.server_name
          context.ip_addresses = message.ip_addresses
          context.event_date = message.event_date
          @communication_queue.enqueue(@chain_factory.client_started_chain(context))
        when MESSAGE_ID_SERVER_PING
          context = ServerPingContext.new
          context.server_name = message.server_name
          context.ip_addresses = message.ip_addresses
          context.event_date = message.event_date
          @communication_queue.enqueue(@chain_factory.server_ping_chain(context))
        when MESSAGE_ID_SERVICES_CHANGED_EVENT
          context = ServicesChangedContext.new
          context.message = message
          @services_data_queue.enqueue(@chain_factory.services_changed_chain(context))
        when MESSAGE_ID_HDDS_CHANGED_EVENT
          context = HddsChangedContext.new
          context.message = message
          @drives_data_queue.enqueue(@chain_factory.hdds_changed_chain(context))
      end
    end
    return ch
  end
end