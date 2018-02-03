class LoadServerConfigurationCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.server_configuration = ServerConfiguration.new
    @context.server_configuration.watched_services.add("Tomcat8")
    @context.server_configuration.watched_drives.add("C:\\")
  end
end