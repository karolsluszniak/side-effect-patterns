module Pubsub
class Exchange
class << self
  def event_handlers
    @event_handlers ||= {}
    @event_handlers
  end

  def emit(event, payload = nil)
    event_handlers[event.to_s]&.each do |handler|
      handler.call(payload)
    end
  end

  def on(event, &block)
    event_handlers[event.to_s] ||= []
    event_handlers[event.to_s].push(block)
  end
end
end
end
