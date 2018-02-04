class CreateServerPingMessageCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    @context.exchange = EXCHANGE_MONITORING_SERVER_PING
    @context.message = ServerPingMessage.new
    @context.message.server_name = Socket.gethostname
    @context.routing_key = @context.message.message_id
    Socket.ip_address_list().each do |i|
      @context.message.ip_addresses.add(i.ip_address())
    end
  end
end