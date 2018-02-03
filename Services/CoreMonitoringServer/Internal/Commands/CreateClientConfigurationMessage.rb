class CreateClientConfigurationMessage < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.exchange = EXCHANGE_MONITORING_COMMUNICATION
    @context.message = MonitoringClientConfigurationMessage.new
    @context.message.watched_services = @context.server_configuration.watched_services
    @context.message.watched_drives = @context.server_configuration.watched_drives
    @context.routing_key = @context.message.message_id + "." + @context.server_name
    sleep 2
  end
end