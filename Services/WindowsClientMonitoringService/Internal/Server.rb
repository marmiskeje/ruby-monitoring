require 'set'
require 'facets/timer'
require "../../Common/ExecutableCommand"
require "../../Common/ErrorHandlingCommand"
require "../../Common/ExecutableCommandChainCreator"
require "../../Common/CommandProcessingQueue"
require "./Contracts/ServiceInfo"
require "./Contracts/HardDriveInfo"
require "../../Messaging/Contracts/Constants"
require "../../Messaging/Contracts/Data/WatchedHddInfo"
require "../../Messaging/Contracts/Data/WatchedServiceInfo"
require "../../Messaging/Contracts/ServerPingMessage"
require "../../Messaging/Contracts/MonitoringClientStartedMessage"
require "../../Messaging/Contracts/MonitoringClientConfigurationMessage"
require "../../Messaging/Contracts/HddsChangedEventMessage"
require "../../Messaging/Contracts/ServicesChangedEventMessage"
require "./Internal/Contexts/MessagingContext"
require "./Internal/Contexts/ServicesMonitoringContext"
require "./Internal/Contexts/HardDrivesMonitoringContext"
require "./Internal/Contexts/ConfigurationChangedContext"
require "./Internal/Commands/SendMqMessageCommand"
require "./Internal/Commands/CreateMonitoringClientStartedMessageCommand"
require "./Internal/Commands/CreateServerPingMessageCommand"
require "./Internal/Commands/CompareServicesCommand"
require "./Internal/Commands/GenerateServicesEventsCommand"
require "./Internal/Commands/GetAllServicesCommand"
require "./Internal/Commands/GetHardDrivesCommand"
require "./Internal/Commands/CompareHardDrivesCommand"
require "./Internal/Commands/GenerateHardDriveEventsCommand"
require "./Internal/Commands/UpdateDrivesToLatestCommand"
require "./Internal/Commands/UpdateServicesToLatestCommand"
require "./Internal/Commands/GenerateHardDriveEventsCommand"
require "./Internal/Commands/UpdateConfigurationCommand"
require "./Internal/CommandChainFactories/MonitoringCommandChainFactory"

class Server

  def initialize(settings_service, data_service, mq_client)
    @processing_queue = CommandProcessingQueue.new
    @ping_timer = nil
    @services_timer = nil
    @hdds_timer = nil
    @settings_service = settings_service
    @data_service = data_service
    @chain_factory = MonitoringCommandChainFactory.new(mq_client, data_service, settings_service)
    @subscription_channel = create_subscriptions(mq_client)
    @chain_factory.client_started_chain(MessagingContext.new).execute()
  end

  public
  def start
    @ping_timer = Timer.new(2) do |x|
      ping_timer_job()
    end
    @ping_timer.start

    @services_timer = Timer.new(1) do |x|
      services_timer_job()
    end
    @services_timer.start

    @hdds_timer = Timer.new(60) do |x|
      hdds_timer_job()
    end
    @hdds_timer.start
  end

  def stop
    if @ping_timer.nil? == false
      @ping_timer.stop
    end
    if @services_timer.nil? == false
      @services_timer.stop
    end
    if @hdds_timer.nil? == false
      @hdds_timer.stop
    end
  end

  def dispose
    stop()
    @subscription_channel.close()
    @processing_queue.dispose()
  end

  private
  def ping_timer_job
    context = MessagingContext.new
    @chain_factory.server_ping_chain(context).execute()

    @ping_timer.start
  end

  def services_timer_job
    services_context = ServicesMonitoringContext.new
    services_context.watched_services = @settings_service.watched_services
    @processing_queue.enqueue(@chain_factory.services_chain(services_context))

    @services_timer.start
  end

  def hdds_timer_job
    hdds_context = HardDrivesMonitoringContext.new
    hdds_context.watched_drives = @settings_service.watched_drives
    @processing_queue.enqueue(@chain_factory.hdds_chain(hdds_context))
   
    @hdds_timer.start
  end

  def create_subscriptions(mq_client)
    ch = mq_client.create_channel
    queue = ch.queue(Socket.gethostname + "ClientQueue", opts = {:durable => false, :exclusive => true})
    queue.bind(EXCHANGE_MONITORING_COMMUNICATION, opts = {:routing_key => MESSAGE_ID_MONITORING_CLIENT_CONFIGURATION + "." + Socket.gethostname})
    
    queue.subscribe do |delivery_info, metadata, payload|
      message = Marshal::load(payload)
      case message.message_id
        when MESSAGE_ID_MONITORING_CLIENT_CONFIGURATION
          context = ConfigurationChangedContext.new()
          context.message = message
          @processing_queue.enqueue(@chain_factory.configuration_changed_chain(context))
      end
    end
    return ch
  end
end