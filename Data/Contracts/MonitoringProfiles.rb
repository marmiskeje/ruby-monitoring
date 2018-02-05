class MonitoringProfile
  attr_accessor :action, :severity
  def initialize(options={})
    @action = options.fetch(:action, MonitoringAction::NoAction)
    @severity = options.fetch(:severity, MonitoringSeverity::Info)
  end
end

module MonitoringAction
  NoAction = "NoAction"
  EmailAction = "EmailAction"
end

module MonitoringSeverity
  Info = "Info"
  Warning = "Warning"
  Critical = "Critical"
  Error = "Error"
end