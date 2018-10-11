module Pubsub
  module_function

  def emit(event, payload = nil)
    Pubsub::Hub.emit(event, payload)
  end

  def on(event, &block)
    Pubsub::Hub.on(event, &block)
  end
end

require_relative "./hub.rb"
require_relative "./event.rb"
require_relative "./handler.rb"
