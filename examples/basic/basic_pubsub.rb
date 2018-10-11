require_relative "../../lib/pubsub/pubsub.rb"

class Service
  def call
    num = rand(10)
    puts "Generated #{num}"
    ServiceEvent.new(num).emit
    puts "Completed"
  end
end

class SideEffect
  def initialize(num)
    @num = num
  end

  def call
    puts "Acted on #{@num}"
  end
end

class ServiceEvent < Pubsub::Event
  attr_accessor :num

  def initialize(num)
    @num = num
  end
end

class ServiceHandler < Pubsub::Handler
  subscribes_to "ServiceEvent"

  def call
    SideEffect.new(payload.num).call
  end
end
