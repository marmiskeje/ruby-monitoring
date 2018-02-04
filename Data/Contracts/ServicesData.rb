require 'set'

class ServicesData
  attr_accessor :services
  def initialize()
    @services = {}
  end
end

class ServiceData
  attr_accessor :events, :display_name, :name
  def initialize()
    @events = SortedSet.new
  end
end

class ServiceEvent
  include Comparable
  attr_accessor :date, :state

  def initialize()
    @state = "unknown"
  end

  def <=> (other)
     other.date <=> @date
  end

  def to_s
    @date.to_s + " " + state
  end
end