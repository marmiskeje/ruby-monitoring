class CreateClientConfigurationMessage < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.exchange = EXCHANGE_MONITORING_COMMUNICATION
    @context.message = MonitoringClientConfigurationMessage.new
    @context.server_configuration.watched_services.each do |k,v|
      @context.message.watched_services.add(k)
    end
    @context.server_configuration.watched_drives.each do |k,v|
      @context.message.watched_drives.add(k)
    end
    @context.routing_key = @context.message.message_id + "." + @context.server_name
    sleep 2
  end
end