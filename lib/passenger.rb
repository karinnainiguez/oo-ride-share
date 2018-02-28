module RideShare
  class Passenger
    attr_reader :id, :name, :phone_number, :trips

    def initialize(input)
      if input[:id] == nil || input[:id] <= 0
        raise ArgumentError.new("ID cannot be blank or less than zero.")
      end

      @id = input[:id]
      @name = input[:name]
      @phone_number = input[:phone]
      @trips = input[:trips] == nil ? [] : input[:trips]
    end # initialize

    def get_drivers
      @trips.map{ |t| t.driver }
    end # get_drivers

    def add_trip(trip)
      @trips << trip
    end # add_trip

    def total_money
      total = @trips.map {|trip| trip.cost}.sum
      return total
    end # total_spent

    def total_time
      total = @trips.map {|trip| trip.duration}.sum
      return total
    end # total_time

  end # Class Passenger
end # Module RideShare
