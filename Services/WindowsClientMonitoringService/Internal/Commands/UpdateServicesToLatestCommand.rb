class UpdateServicesToLatestCommand < ExecutableCommand
  def initialize(context, data_service)
    super()
    @context = context
    @data_service = data_service
  end
  
  def on_execute
    @data_service.services = @context.latest_services
  end
end