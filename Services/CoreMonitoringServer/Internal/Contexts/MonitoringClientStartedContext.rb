require_relative "MessagingContext"

class MonitoringClientStartedContext < MessagingContext
  attr_accessor :server_name, :ip_addresses, :server_configuration
end