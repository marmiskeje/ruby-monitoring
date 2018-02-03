class CompareServicesCommand < ExecutableCommand
  def initialize(context, services)
    super()
    @context = context
    @services = services
  end

  def on_execute()
    @context.changed_services = {}
    @context.latest_services.each do |k,v|
      previous_state = nil
      if @services.has_key?(k)
        previous_state = @services[k].state
      end
      if v.state != previous_state
        @context.changed_services[k] = v
      end
    end
  end
end