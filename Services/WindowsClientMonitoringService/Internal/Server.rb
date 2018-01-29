require 'set'
require 'facets/timer'
require "../../Common/ExecutableCommand"
require "../../Common/ErrorHandlingCommand"
require "../../Common/ExecutableCommandChainCreator"
require "./Contracts/ServiceInfo"
require "./Contracts/HardDriveInfo"
require "./Internal/Contexts/ServicesMonitoringContext"
require "./Internal/Contexts/HardDrivesMonitoringContext"
require "./Internal/Commands/CompareServicesCommand"
require "./Internal/Commands/GenerateServicesEventsCommand"
require "./Internal/Commands/GetAllServicesCommand"
require "./Internal/Commands/GetHardDrivesCommand"
require "./Internal/Commands/CompareHardDrivesCommand"
require "./Internal/Commands/GenerateHardDriveEventsCommand"
require "./Internal/CommandChainFactories/MonitoringCommandChainFactory"

class Server

  def initialize(settings_service)
    @services_timer = nil
    @hdds_timer = nil
    @services = {}
    @drives = {}
    @settings_service = settings_service
    @chain_factory = MonitoringCommandChainFactory.new
  end

  public
  def start
    @services_timer = Timer.new(1) do |x|
      services_timer_job()
    end
    @services_timer.start

    @hdds_timer = Timer.new(60) do |x|
      hdds_timer_job()
    end
    hdds_timer_job()
    @hdds_timer.start
  end

  def stop
    if @services_timer.nil? == false
      @services_timer.stop
    end
    if @hdds_timer.nil? == false
      @hdds_timer.stop
    end
  end

  private
  def fetch_all_services
    services = {}
    Win32::Service.services do |s|
      if s.service_type == "own process" || s.service_type == "share process" # ignore drivers
        to_add = ServiceInfo.new
        to_add.name = s.service_name
        to_add.display_name = s.display_name
        to_add.state = s.current_state
        services[s.service_name] = to_add
      end
    end
    services
  end

  def services_timer_job
    return
    services_context = ServicesMonitoringContext.new
    services_context.watched_services = @settings_service.watched_services
    services_context.previous_services = @services
    @chain_factory.services_chain(services_context).execute()
    @services = services_context.latest_services

    @services_timer.start
  end

  def hdds_timer_job
    hdds_context = HardDrivesMonitoringContext.new
    hdds_context.watched_drives = @settings_service.watched_drives
    hdds_context.previous_drives_with_info = @drives
    @chain_factory.hdds_chain(hdds_context).execute()
    @drives = hdds_context.latest_drives_with_info

    @hdds_timer.start
  end
end