require 'set'

class HddsData
  attr_accessor :drives
  def initialize()
    @drives = {}
  end
end

class HddData
  attr_accessor :events, :path
  def initialize()
    @events = SortedSet.new
  end
end

class HddEvent
  include Comparable
  attr_accessor :date, :total_bytes, :free_bytes

  def initialize()
    @total_bytes = 0
    @free_bytes = 0
  end

  def free_space_percentage
    if total_bytes > 0
      return (free_bytes / total_bytes.to_f) * 100.0
    end
    return 0
  end

  def <=> (other)
     other.date <=> @date
  end

  def to_s
    @date.to_s + " free: " + free_space_percentage.to_s + "%"
  end
end