class ServerConfiguration
  attr_accessor :watched_drives, :watched_services

  def initialize()
    @watched_drives = Set.new
    @watched_services = Set.new
  end
end