class GenerateServicesEventsCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.changed_services.each do |k,v|
      if @context.watched_services.include?(k)
        print(v.name + "  " + v.state)
        # publish message
      end
    end
  end
end