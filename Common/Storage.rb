class Storage
  def initialize(redis)
    @redis = redis
    @lock = Concurrent::ReadWriteLock.new
  end

  def reader_accessor(&block)
    @lock.with_read_lock { block.call }
  end

  def writer_accessor(&block)
    @lock.with_write_lock { block.call }
  end

  protected
  def protected_set(key, value)
    @redis.set(key, Marshal::dump(value))
  end

  def protected_get(key)
    val = @redis.get(key)
    if !val.nil?
      return Marshal::load(val)
    end
    return nil
  end

end