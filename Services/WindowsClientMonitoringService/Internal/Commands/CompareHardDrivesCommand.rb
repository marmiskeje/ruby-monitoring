class CompareHardDrivesCommand < ExecutableCommand
  def initialize(context, drives)
    super()
    @context = context
    @drives = drives
  end

  def on_execute()
    @context.changed_drives_with_info = {}
    @context.latest_drives_with_info.each do |k,v|
      is_change = true
      if @drives.has_key?(k)
        previous = @drives[k]
        is_change = previous.total_bytes != v.total_bytes || previous.free_bytes != v.free_bytes
      end
      if is_change
        @context.changed_drives_with_info[k] = v
      end
    end
  end
end