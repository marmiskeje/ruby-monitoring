class GenerateHardDriveEventsCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end

  def on_execute()
    @context.changed_drives_with_info.each do |k,v|
      print(v.path + "    " + v.free_bytes.to_s)
      # publish message
    end
  end
end