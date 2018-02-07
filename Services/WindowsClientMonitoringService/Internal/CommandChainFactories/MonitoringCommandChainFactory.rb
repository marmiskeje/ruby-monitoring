class MonitoringCommandChainFactory
  def initialize(mq_client, data_service, settings_service)
    @mq_client = mq_client
    @data_service = data_service
    @settings_service = settings_service
  end

  def services_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(ErrorHandlingCommand.new)
    chain_creator.add(GetAllServicesCommand.new(context))
    chain_creator.add(CompareServicesCommand.new(context, @data_service.services))
    chain_creator.add(UpdateServicesToLatestCommand.new(context, @data_service))
    chain_creator.add(GenerateServicesEventsCommand.new(context, @settings_service))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

  def hdds_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(ErrorHandlingCommand.new)
    chain_creator.add(GetHardDrivesCommand.new(context))
    chain_creator.add(CompareHardDrivesCommand.new(context, @data_service.drives))
    chain_creator.add(UpdateDrivesToLatestCommand.new(context, @data_service))
    chain_creator.add(GenerateHardDriveEventsCommand.new(context, @settings_service))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

  def client_started_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(CreateMonitoringClientStartedMessageCommand.new(context, @settings_service))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

  def server_ping_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(CreateServerPingMessageCommand.new(context, @settings_service))
    chain_creator.add(SendMqMessageCommand.new(context, @mq_client))
    chain_creator.first_command
  end

  def configuration_changed_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(UpdateConfigurationCommand.new(context, @settings_service, @data_service))
    chain_creator.first_command
  end
end