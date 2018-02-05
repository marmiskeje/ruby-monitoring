class ServerConfiguration
  attr_accessor :watched_drives, :watched_services

  def initialize()
    @watched_drives = {}
    @watched_services = {}
  end
end