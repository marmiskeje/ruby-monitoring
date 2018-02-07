require 'json'
require 'set'
require 'redis'
require '../../Common/Storage'
require '../../Data/Contracts/StorageKeys'
require '../../Data/Contracts/AllServersData'
require '../../Data/Contracts/ServerData'
require '../../Data/Contracts/ServicesData'
require '../../Data/Contracts/HddsData'

class AllServersStorage < Storage
  def initialize(redis)
    super(redis)
  end

  def get()
    protected_get(STORAGE_KEY_ALL_SERVERS)
  end

  def set(val)
    protected_set(STORAGE_KEY_ALL_SERVERS, val)
  end
end

class ServicesStorage < Storage
  def initialize(redis)
    super(redis)
  end

  def get(server_name)
    key = STORAGE_KEY_FORMAT_SERVER_SERVICES % [server_name]
    protected_get(key)
  end

  def set(server_name, val)
    key = STORAGE_KEY_FORMAT_SERVER_SERVICES % [server_name]
    protected_set(key, val)
  end
end

class HddsStorage < Storage
  def initialize(redis)
    super(redis)
  end

  def get(server_name)
    key = STORAGE_KEY_FORMAT_SERVER_HDDS % [server_name]
    protected_get(key)
  end

  def set(server_name, val)
    key = STORAGE_KEY_FORMAT_SERVER_HDDS % [server_name]
    protected_set(key, val)
  end
end

class ApiController < ActionController::Base

  def servers
    redis = Redis.new
    storage = AllServersStorage.new(redis)

    servers = []
    storage.reader_accessor do |x|
      servers_data = storage.get()
      if !servers_data.nil?
        servers_data.servers.each do |k, v|
          servers.append({:name => k, :is_online => v.is_online})
        end
      end
    end
    
    redis.close
    render :json => servers.to_json
  end

  def server_data
    tmp = SortedSet.new # otherwise sortedset is not sorted
    server_name = params[:server_name]
    redis = Redis.new
    services_storage = ServicesStorage.new(redis)
    hdds_storage = HddsStorage.new(redis)

    services = []
    hdds = []
    services_storage.reader_accessor do |x|
      services_data = services_storage.get(server_name)
      if !services_data.nil?
        services_data.services.each do |k, v|
          state = "unknown"
          change_date = nil
          v.events.each do |e|
            state = e.state
            change_date = e.date
            break;
          end
          services.append({:display_name => v.display_name, :state => state, :change_date => change_date})
        end
      end
    end
    hdds_storage.reader_accessor do |x|
      hdds_data = hdds_storage.get(server_name)
      if !hdds_data.nil?
        hdds_data.drives.each do |k, v|
          total_bytes = 0
          free_bytes = 0
          change_date = nil
          v.events.each do |e|
            total_bytes = e.total_bytes
            free_bytes = e.free_bytes
            change_date = e.date
            break;
          end
          hdds.append({:path => v.path, :total_bytes => total_bytes, :free_bytes => free_bytes, :change_date => change_date})
        end
      end
    end
    redis.close
    render :json => {:services => services, :hdds => hdds}
  end
end