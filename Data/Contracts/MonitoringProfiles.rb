class MonitoringProfile
  attr_accessor :action, :severity
  def initialize(options={})
    @action = options.fetch(:action, MonitoringAction::NoAction)
    @severity = options.fetch(:severity, MonitoringSeverity::Info)
  end
end

module MonitoringAction
  NoAction = 0
  EmailAction = 1
end

module MonitoringSeverity
  Info = 0
  Warning = 2
  Critical = 4
  Error = 8
end