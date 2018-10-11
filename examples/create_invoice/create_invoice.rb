consts = %i[Sales Calendar Customers Inventory Analytics]

puts "====> create invoice (call)"
require_relative "./create_invoice_call.rb"
Sales.create_invoice(123)
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> create invoice (pubsub)"
require_relative "./create_invoice_pubsub.rb"
Sales.create_invoice(123)
consts.each { |const| Object.send(:remove_const, const) }
puts

puts "====> create invoice (observer)"
require_relative "./create_invoice_observer.rb"
Sales.create_invoice(123)
consts.each { |const| Object.send(:remove_const, const) }
puts
