class CommandProcessingQueue
  include Concurrent::Synchronization::Volatile
  attr_volatile :is_disposed

  def initialize()
    @is_disposed = false
    @enqueue_event = Concurrent::Event.new
    @queue = Queue.new
    @lock = Mutex.new
    @worker = Thread.new { worker_work }
  end

  public
  def enqueue(command)
    if !@is_disposed
      @lock.synchronize {
        @queue.enq(command)
        @enqueue_event.set()
      }
    end
  end

  def dispose()
    @is_disposed = true
    @enqueue_event.set()
    if !(@worker.join(5))
      @worker.exit()
    end
  end

  private
  def worker_work()
    while !@is_disposed do
      @enqueue_event.wait()
      process_queue()
    end
    process_queue()
  end

  def process_queue()
    if !@is_disposed
      command = nil
      @lock.synchronize {
        if @queue.empty?
          @enqueue_event.reset()
        else
          command = @queue.deq()
        end
      }
      if !command.nil?
        begin
          command.execute()
        rescue Exception => e
          print(e.class.name + ": " + e.message)
          # todo log
        end
      end
    end
  end
end