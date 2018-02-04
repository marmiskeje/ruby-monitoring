require 'set'
class CreateOrUpdateServicesDataCommand < ExecutableCommand
  def initialize(context, services_storage)
    super()
    @context = context
    @services_storage = services_storage
  end

  def on_execute()
    tmp = SortedSet.new # must be present otherwise none SortedSet is not ordered
    @services_storage.writer_accessor do |x|
      services_data = @services_storage.get(@context.message.server_name)
      if services_data.nil?
        services_data = ServicesData.new
      end
      @context.message.changed_services.each do |s|
        service_data = services_data.services[s.name]
        if service_data.nil?
          service_data = ServiceData.new
        end
        service_data.name = s.name
        service_data.display_name = s.display_name
        event = ServiceEvent.new
        event.date = @context.message.event_date
        event.state = s.state
        service_data.events.add(event)
        services_data.services[s.name] = service_data
        puts("updated service!! " + s.name + " " + event.to_s)
      end
      @services_storage.set(@context.message.server_name, services_data)
    end
  end
end