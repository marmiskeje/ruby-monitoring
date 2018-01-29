class GetAllServicesCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    @context.latest_services = {}
    Win32::Service.services do |s|
      if s.service_type == "own process" || s.service_type == "share process" # ignore drivers
        to_add = ServiceInfo.new
        to_add.name = s.service_name
        to_add.display_name = s.display_name
        to_add.state = s.current_state
        @context.latest_services[s.service_name] = to_add
      end
    end
  end
end