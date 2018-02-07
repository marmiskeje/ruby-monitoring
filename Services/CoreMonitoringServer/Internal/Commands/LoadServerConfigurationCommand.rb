class LoadServerConfigurationCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.server_configuration = ServerConfiguration.new
    puts(@context.server_name)
    if @context.server_name == "TstAppServer"
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_services["wuauserv"] = service_conf
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_services["Dnscache"] = service_conf
      hdd_conf = HddConfiguration.new
      hdd_conf.free_space_percentage_profiles[15] = MonitoringProfile.new(options = { :action => MonitoringAction::NoAction, :severity => MonitoringSeverity::Info })
      hdd_conf.free_space_percentage_profiles[10] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Warning })
      hdd_conf.free_space_percentage_profiles[5] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_drives["D:\\"] = hdd_conf
    else
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_services["Redis"] = service_conf
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_services["RabbitMQ"] = service_conf
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_services["Tomcat8"] = service_conf
      service_conf = ServiceConfiguration.new
      service_conf.state_profiles["running"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      service_conf.state_profiles["stopped"] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Info })
      @context.server_configuration.watched_services["Tomcat7"] = service_conf
      hdd_conf = HddConfiguration.new
      hdd_conf.free_space_percentage_profiles[15] = MonitoringProfile.new(options = { :action => MonitoringAction::NoAction, :severity => MonitoringSeverity::Info })
      hdd_conf.free_space_percentage_profiles[10] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Warning })
      hdd_conf.free_space_percentage_profiles[5] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_drives["C:\\"] = hdd_conf
      hdd_conf = HddConfiguration.new
      hdd_conf.free_space_percentage_profiles[15] = MonitoringProfile.new(options = { :action => MonitoringAction::NoAction, :severity => MonitoringSeverity::Info })
      hdd_conf.free_space_percentage_profiles[10] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Warning })
      hdd_conf.free_space_percentage_profiles[5] = MonitoringProfile.new(options = { :action => MonitoringAction::EmailAction, :severity => MonitoringSeverity::Critical })
      @context.server_configuration.watched_drives["D:\\"] = hdd_conf
    end
  end
end