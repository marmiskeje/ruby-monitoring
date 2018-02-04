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