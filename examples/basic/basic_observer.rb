require_relative "../../lib/observer/main.rb"

class Service
  def call
    num = rand(10)
    puts "Generated #{num}"
    ServiceSignal.new(num).emit
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

class ServiceSignal < Observer::Signal
  emits_to "ServiceObserver"

  attr_accessor :num

  def initialize(num)
    @num = num
  end
end

class ServiceObserver < Observer::Observer
  def call
    SideEffect.new(payload.num).call
  end
end
