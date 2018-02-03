require_relative "MessagingContext"

class ServicesMonitoringContext < MessagingContext
  attr_accessor :latest_services, :changed_services, :watched_services
end