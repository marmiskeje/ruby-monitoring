require_relative "Constants"
require_relative "BaseMessage"

class HddsChangedEventMessage < BaseMessage
  attr_accessor :server_name, :changed_drives
  
  def initialize()
    super()
    @message_id = MESSAGE_ID_HDDS_CHANGED_EVENT
    @changed_drives = []
  end
end