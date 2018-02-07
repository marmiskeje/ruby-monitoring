require 'date'
class CreateMonitoringClientStartedMessageCommand < ExecutableCommand
  def initialize(context, settings_service)
    super()
    @context = context
    @settings_service = settings_service
  end
  def on_execute
    @context.exchange = EXCHANGE_MONITORING_COMMUNICATION
    @context.message = MonitoringClientStartedMessage.new
    @context.message.server_name = @settings_service.server_name
    @context.message.event_date = DateTime.now
    @context.routing_key = @context.message.message_id
    Socket.ip_address_list().each do |i|
      @context.message.ip_addresses.add(i.ip_address())
    end
  end
end