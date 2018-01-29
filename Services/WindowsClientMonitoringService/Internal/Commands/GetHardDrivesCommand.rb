class GetHardDrivesCommand < ExecutableCommand
  def initialize(context)
    super()
    @context = context
  end
  def on_execute
    @context.latest_drives_with_info = {}
    @context.watched_drives.each do |d|
      info = Filesystem.stat(d)
      to_add = HardDriveInfo.new
      to_add.path = d
      to_add.total_bytes = info.bytes_total
      to_add.free_bytes = info.bytes_free
      @context.latest_drives_with_info[d] = to_add
    end
  end
end