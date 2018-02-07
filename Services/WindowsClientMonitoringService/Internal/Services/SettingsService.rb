class SettingsService
  attr_accessor :watched_services, :watched_drives
  def initialize()
    @watched_services = Set.new
    @watched_drives = Set.new
  end

  def server_name
    Socket.gethostname
  end
end