require 'win32/service'
require 'sys/filesystem'
include Sys

require "./Internal/Server"
require "./Internal/Settings/SettingsService"
settings_service = SettingsService.new
server = Server.new(settings_service).start


loop do
  sleep 300
end
