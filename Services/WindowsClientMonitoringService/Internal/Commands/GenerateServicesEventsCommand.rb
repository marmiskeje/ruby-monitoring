require 'date'
class GenerateServicesEventsCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    message = ServicesChangedEventMessage.new
    message.server_name = Socket.gethostname
    message.event_date = DateTime.now
    @context.exchange = EXCHANGE_MONITORING_DATA
    @context.routing_key = message.message_id
    @context.changed_services.each do |k,v|
      if @context.watched_services.include?(k)
        to_add = WatchedServiceInfo.new
        to_add.name = v.name
        to_add.display_name = v.display_name
        to_add.state = v.state
        message.changed_services.push(to_add)
        puts(v.name + "  " + v.state)
      end
    end
    @context.message = message
    @is_succesor_call_enabled = message.changed_services.size > 0
  end
end