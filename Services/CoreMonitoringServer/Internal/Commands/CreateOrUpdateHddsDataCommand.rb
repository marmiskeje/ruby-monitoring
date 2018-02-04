require 'set'
class CreateOrUpdateHddsDataCommand < ExecutableCommand
  def initialize(context, hdds_storage)
    super()
    @context = context
    @hdds_storage = hdds_storage
  end

  def on_execute()
    tmp = SortedSet.new # must be present otherwise none SortedSet is not ordered
    @hdds_storage.writer_accessor do |x|
      drives_data = @hdds_storage.get(@context.message.server_name)
      if drives_data.nil?
        drives_data = HddsData.new
      end
      @context.message.changed_drives.each do |d|
        hdd_data = drives_data.drives[d.path]
        if hdd_data.nil?
          hdd_data = HddData.new
        end
        hdd_data.path = d.path
        event = HddEvent.new
        event.date = @context.message.event_date
        event.total_bytes = d.total_bytes
        event.free_bytes = d.free_bytes
        hdd_data.events.add(event)
        drives_data.drives[d.path] = hdd_data
        puts("updated hdd!! " + d.path + " " + event.to_s)
      end
      @hdds_storage.set(@context.message.server_name, drives_data)
    end
  end
end