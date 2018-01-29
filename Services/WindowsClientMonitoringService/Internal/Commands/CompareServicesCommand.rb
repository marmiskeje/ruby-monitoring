class CompareServicesCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.changed_services = {}
    @context.latest_services.each do |k,v|
      previous_state = nil
      if @context.previous_services.has_key?(k)
        previous_state = @context.previous_services[k].state
      end
      if v.state != previous_state
        @context.changed_services[k] = v
      end
    end
  end
end