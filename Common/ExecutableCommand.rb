class ExecutableCommand
  def initialize()
    @is_succesor_call_enabled = true
    @successor = nil;
  end

  public
  def execute
    on_execute()
    try_call_successor()
  end

  def successor=(command)
    @successor = command
  end

  protected
  def on_execute
    fail NotImplementedError, "Method on_execute is not implemented in " + self.class.name
  end

  private
  def try_call_successor
    if @successor.nil? == false && @is_succesor_call_enabled
      @successor.execute()
    end
  end

end