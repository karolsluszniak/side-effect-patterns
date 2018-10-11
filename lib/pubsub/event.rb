module Pubsub
class Event
  def emit
    Pubsub.emit(self.class, self)
  end
end
end
