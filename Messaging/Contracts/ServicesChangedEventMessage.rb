require_relative "Constants"
require_relative "BaseMessage"

class ServicesChangedEventMessage < BaseMessage
  attr_accessor :server_name, :changed_services
  
  def initialize()
    super()
    @message_id = MESSAGE_ID_SERVICES_CHANGED_EVENT
    @changed_services = []
  end
end