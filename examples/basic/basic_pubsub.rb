require_relative "../../lib/pubsub/pubsub.rb"

class Subject
  def call
    num = rand(10)
    puts "Generated #{num}"
    SubjectEvent.new(num).emit
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

class SubjectEvent < Pubsub::Event
  attr_accessor :num

  def initialize(num)
    @num = num
  end
end

class SubjectHandler < Pubsub::Handler
  subscribe_to SubjectEvent

  def handle
    SideEffect.new(payload.num).call
  end
end
