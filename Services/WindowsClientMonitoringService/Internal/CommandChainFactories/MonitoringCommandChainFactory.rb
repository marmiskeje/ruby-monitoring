class MonitoringCommandChainFactory
  def services_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(ErrorHandlingCommand.new)
    chain_creator.add(GetAllServicesCommand.new(context))
    chain_creator.add(CompareServicesCommand.new(context))
    chain_creator.add(GenerateServicesEventsCommand.new(context))
    chain_creator.first_command
  end

  def hdds_chain(context)
    chain_creator = ExecutableCommandChainCreator.new
    chain_creator.add(ErrorHandlingCommand.new)
    chain_creator.add(GetHardDrivesCommand.new(context))
    chain_creator.add(CompareHardDrivesCommand.new(context))
    chain_creator.add(GenerateHardDriveEventsCommand.new(context))
    chain_creator.first_command
  end
end