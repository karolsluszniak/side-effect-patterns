module Pubsub
class Handler
  class << self
    def subscribe_to(event)
      Pubsub.on(event) do |payload|
        self.new(event, payload).handle
      end
    end
  end

  attr_reader :event, :payload

  def initialize(event, payload)
    @event = event
    @payload = payload
  end
end
end
