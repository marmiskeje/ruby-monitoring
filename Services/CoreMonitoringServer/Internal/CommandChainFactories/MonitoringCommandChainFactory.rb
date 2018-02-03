class MonitoringCommandChainFactory
  def initialize(mq_client)
    @mq_client = mq_client
  end

  def client_started_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(CreateServerIfNeededCommand.new(context))
    chain_creator.add(LoadServerConfigurationCommand.new(context))
    chain_creator.add(CreateClientConfigurationMessage.new(context))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

end