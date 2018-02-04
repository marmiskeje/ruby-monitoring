require 'win32/service'
require 'sys/filesystem'
require 'socket'
require "bunny"
require 'thread'
require 'concurrent'
include Sys

require "./Internal/Server"
require "./Internal/Services/SettingsService"
require "./Internal/Services/DataService"

data_service = DataService.new
settings_service = SettingsService.new
mq_client = Bunny.new
mq_client.start
server = Server.new(settings_service, data_service, mq_client)
server.start()

gets()
server.stop()
server.dispose()
mq_client.stop