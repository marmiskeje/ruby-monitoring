class DataService
  attr_accessor :services, :drives

  def initialize()
    @services = {}
    @drives = {}
  end
end