class SendMqMessageCommand < ExecutableCommand
  def initialize(context, mq_client)
    super()
    @context = context
    @mq_client = mq_client
  end
  def on_execute
    ch = @mq_client.create_channel()
    begin
      ch.basic_publish(@context.message.serialize(), @context.exchange, @context.routing_key)
    ensure
      ch.close()
    end
  end
end