module Pubsub
  module_function

  def emit(event, payload = nil)
    Pubsub::Exchange.emit(event, payload)
  end

  def on(event, &block)
    Pubsub::Exchange.on(event, &block)
  end
end

require_relative "./exchange.rb"
require_relative "./event.rb"
require_relative "./handler.rb"
