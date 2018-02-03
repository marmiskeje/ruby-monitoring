require_relative "MessagingContext"

class HardDrivesMonitoringContext < MessagingContext
  attr_accessor :watched_drives, :latest_drives_with_info, :changed_drives_with_info
end