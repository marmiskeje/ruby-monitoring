class CreateOrUpdateServerIfNeededCommand < ExecutableCommand
  def initialize(context, all_servers_storage)
    super()
    @context = context
    @all_servers_storage = all_servers_storage
  end

  def on_execute()
    @all_servers_storage.writer_accessor do |x|
      all_servers = @all_servers_storage.get()
      update_needed = false
      if all_servers.nil?
        all_servers = AllServersData.new
        update_needed = true
      end
      if !all_servers.servers.has_key?(@context.server_name)
        all_servers.servers[@context.server_name] = ServerData.new
        update_needed = true
      end
      server_data = all_servers.servers[@context.server_name]
      if !server_data.ip_addresses.subset?(@context.ip_addresses) || !@context.ip_addresses.subset?(server_data.ip_addresses)
        server_data.ip_addresses = @context.ip_addresses
        update_needed = true
      end
      if update_needed
        @all_servers_storage.set(all_servers)
        puts("updated all servers!!")
      end
    end
  end
end