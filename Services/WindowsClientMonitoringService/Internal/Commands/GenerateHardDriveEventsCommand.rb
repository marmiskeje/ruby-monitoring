require 'date'
class GenerateHardDriveEventsCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    message = HddsChangedEventMessage.new
    message.server_name = Socket.gethostname
    message.event_date = DateTime.now
    @context.exchange = EXCHANGE_MONITORING_DATA
    @context.routing_key = message.message_id
    @context.changed_drives_with_info.each do |k,v|
      to_add = WatchedHddInfo.new
      to_add.path = v.path
      to_add.total_bytes = v.total_bytes
      to_add.free_bytes = v.free_bytes
      message.changed_drives.push(to_add)
      puts(v.path + "    " + v.free_bytes.to_s)
    end
    @context.message = message
    @is_succesor_call_enabled = message.changed_drives.size > 0
  end
end