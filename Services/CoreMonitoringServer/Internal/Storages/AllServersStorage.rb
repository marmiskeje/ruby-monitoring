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