class ServerData
  attr_accessor :ip_addresses

  def initialize()
    @ip_addresses = Set.new
  end
end