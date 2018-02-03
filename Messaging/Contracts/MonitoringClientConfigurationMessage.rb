require_relative "Constants"
require_relative "BaseMessage"

class MonitoringClientConfigurationMessage < BaseMessage
  attr_accessor :watched_services, :watched_drives
  
  def initialize()
    super()
    @message_id = MESSAGE_ID_MONITORING_CLIENT_CONFIGURATION
    @watched_services = Set.new
    @watched_drives = Set.new
  end
end