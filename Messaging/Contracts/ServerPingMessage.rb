require_relative "Constants"
require_relative "BaseMessage"

class ServerPingMessage < BaseMessage
  attr_accessor :server_name, :ip_addresses
  
  def initialize()
    super()
    @message_id = MESSAGE_ID_SERVER_PING
    @ip_addresses = Set.new
  end
end