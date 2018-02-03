class UpdateDrivesToLatestCommand < ExecutableCommand
  def initialize(context, data_service)
    super()
    @context = context
    @data_service = data_service
  end
  
  def on_execute
    @data_service.drives = @context.latest_drives_with_info
  end
end