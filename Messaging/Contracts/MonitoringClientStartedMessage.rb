require_relative "Constants"
require_relative "BaseMessage"

class MonitoringClientStartedMessage < BaseMessage
  attr_accessor :server_name, :ip_addresses, :event_date
  
  def initialize()
    super()
    @message_id = MESSAGE_ID_MONITORING_CLIENT_STARTED
    @ip_addresses = Set.new
  end
end