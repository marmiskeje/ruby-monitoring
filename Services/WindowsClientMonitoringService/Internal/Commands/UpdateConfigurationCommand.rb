class UpdateConfigurationCommand < ExecutableCommand
  def initialize(context, settings_service, data_service)
    super()
    @context = context
    @settings_service = settings_service
    @data_service = data_service
  end
  def on_execute
    @settings_service.watched_services = @context.message.watched_services
    @settings_service.watched_drives = @context.message.watched_drives
    @data_service.services = {}
    @data_service.drives = {}
  end
end