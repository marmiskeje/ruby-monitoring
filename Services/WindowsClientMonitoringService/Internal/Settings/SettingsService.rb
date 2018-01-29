class SettingsService
  attr_accessor :watched_services, :watched_drives
  def initialize()
    @watched_services = Set.new
    @watched_drives = Set.new
    @watched_services.add("Tomcat7")
    @watched_drives.add("D:\\")
  end
end