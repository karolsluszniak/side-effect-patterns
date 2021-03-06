require_relative "../../lib/observer/main.rb"

module Sales
  module_function
  def create_invoice(appointment_id)
    CreateInvoiceService.new(appointment_id).call
  end

  class Invoice
    attr_accessor :id, :number, :provider_id, :appointment_id, :customer_id, :product_ids

    def save
      self.id = (rand * 1000 + 1).round
    end
  end

  class CreateInvoiceService
    def initialize(appointment_id)
      @appointment_id = appointment_id
    end

    def call
      # begin transaction

      invoice = Invoice.new
      invoice.number = sprintf("%06d", rand * 1_000_000)

      appointment = Calendar.get_appointment(@appointment_id)
      invoice.appointment_id = appointment.id
      invoice.provider_id = appointment.provider_id
      invoice.customer_id = appointment.customer_id
      invoice.product_ids = appointment.product_ids

      puts "[Sales] Invoice #{invoice.number} built"

      invoice.save

      InvoiceCreatedSignal.new(invoice).emit

      # commit transaction

      puts "[Sales] Invoice #{invoice.id} persisted along with side-effects"
    end
  end

  class InvoiceCreatedSignal < Observer::Signal
    emits_into %w[Calendar Customers Inventory Analytics]

    # ...or if we don't care about naming convention:
    #
    # emits_to "Calendar::InvoiceCreatedObserver"
    # emits_to "Customers::InvoiceCreatedObserver"
    # emits_to "Inventory::InvoiceCreatedObserver"
    # emits_to "Analytics::InvoiceCreatedObserver"

    attr_reader :provider_id, :appointment_id, :customer_id, :product_ids

    def initialize(invoice)
      @provider_id = invoice.provider_id
      @appointment_id = invoice.appointment_id
      @customer_id = invoice.customer_id
      @product_ids = invoice.product_ids
    end
  end
end

module Calendar
  module_function
  def get_appointment(id)
    Appointment.find(id)
  end

  class Appointment
    attr_accessor :id, :status, :provider_id, :customer_id, :product_ids

    def self.find(id)
      appointment = self.new
      appointment.id = id
      appointment
    end

    def initialize
      @status = :new
      @provider_id = 9830
      @customer_id = 430
      @product_ids = [1, 2, 3]
    end

    def save
    end
  end

  class CompleteAppointmentService
    def initialize(appointment)
      @appointment = appointment
    end

    def call
      # begin transaction

      @appointment.status = :completed
      AppointmentCompletedSignal.new(@appointment).emit
      @appointment.save

      # commit transaction

      puts "[Calendar] Appointment #{@appointment.id} completed"
    end
  end

  class AppointmentCompletedSignal < Observer::Signal
    emits_into %w[Customers Analytics]

    attr_reader :provider_id, :customer_id

    def initialize(appointment)
      @provider_id = appointment.provider_id
      @customer_id = appointment.customer_id
    end
  end

  class InvoiceCreatedObserver < Observer::Observer
    def call
      appointment = Appointment.find(payload.appointment_id)
      CompleteAppointmentService.new(appointment).call
    end
  end
end

module Customers
  class Customer
    attr_accessor :id, :active, :confirmed

    def self.find(id)
      appointment = self.new
      appointment.id = id
      appointment
    end

    def save
    end
  end

  class MarkCustomerActiveService
    def initialize(customer)
      @customer = customer
    end

    def call
      @customer.active = true
      @customer.save

      puts "[Customers] Customer #{@customer.id} marked as active"
    end
  end

  class MarkCustomerConfirmedService
    def initialize(customer)
      @customer = customer
    end

    def call
      @customer.confirmed = true
      @customer.save

      puts "[Customers] Customer #{@customer.id} marked as confirmed"
    end
  end

  class InvoiceCreatedObserver < Observer::Observer
    def call
      customer = Customer.find(payload.customer_id)
      MarkCustomerActiveService.new(customer).call
    end
  end

  class AppointmentCompletedObserver < Observer::Observer
    def call
      customer = Customer.find(payload.customer_id)
      MarkCustomerConfirmedService.new(customer).call
    end
  end
end

module Inventory
  class DecreaseInvoicedStockService
    def initialize(product_ids)
      @product_ids = product_ids
    end

    def call
      # find stock records for each purchased product and decrease them

      puts "[Inventory] Stock for products #{@product_ids.join(", ")} decreased"
    end
  end

  class InvoiceCreatedObserver < Observer::Observer
    def call
      DecreaseInvoicedStockService.new(payload.product_ids).call
    end
  end
end

module Analytics
  class IncreaseInvoiceAccumulatorService
    def initialize(provider_id)
      @provider_id = provider_id
    end

    def call
      # get or create invoice count accumulator and increase it by 1

      puts "[Analytics] Invoice accumulator for provider #{@provider_id} increased"
    end
  end

  class IncreaseCompletedAppointmentAccumulatorService
    def initialize(provider_id)
      @provider_id = provider_id
    end

    def call
      # get or create completed appointment count accumulator and increase it by 1

      puts "[Analytics] Completed appt accumulator for provider #{@provider_id} increased"
    end
  end

  class InvoiceCreatedObserver < Observer::Observer
    def call
      IncreaseInvoiceAccumulatorService.new(payload.provider_id).call
    end
  end

  class AppointmentCompletedObserver < Observer::Observer
    def call
      IncreaseCompletedAppointmentAccumulatorService.new(payload.provider_id).call
    end
  end
end
