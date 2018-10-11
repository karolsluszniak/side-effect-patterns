module Pubsub
class Hub
class << self
  def event_handlers
    @event_handlers ||= {}
    @event_handlers
  end

  def emit(event, payload = nil)
    event_handlers[event]&.each do |handler|
      handler.call(payload)
    end
  end

  def on(event, &block)
    event_handlers[event] ||= []
    event_handlers[event].push(block)
  end
end
end
end
