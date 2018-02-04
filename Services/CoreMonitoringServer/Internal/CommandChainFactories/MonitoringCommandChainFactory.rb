class MonitoringCommandChainFactory
  def initialize(mq_client, all_servers_storage)
    @mq_client = mq_client
    @all_servers_storage = all_servers_storage
  end

  def client_started_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(CreateOrUpdateServerIfNeededCommand.new(context, @all_servers_storage))
    chain_creator.add(LoadServerConfigurationCommand.new(context))
    chain_creator.add(CreateClientConfigurationMessage.new(context))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

end