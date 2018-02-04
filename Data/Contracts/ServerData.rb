require 'date'

class ServerData
  attr_accessor :ip_addresses, :last_ping_date

  def initialize()
    @ip_addresses = Set.new
    @last_ping_date = nil
  end

  def is_online
    if !@last_ping_date.nil?
      diff = DateTime.now - last_ping_date # in days
      diff_seconds = diff * 24 * 60 * 60
      return diff_seconds >= 0 && diff_seconds <= 3
    end
    return false
  end
end