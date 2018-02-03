class Storage
  def initialize()
    @dict = Hash.new
  end

  def reader_accessor(&block)
    block.call
  end

  def writer_accessor(&block)
    block.call
  end

  def add_or_update(key, value)
    dict[key] = value
  end

  def remove(key)
    dict.delete(key)
  end

end