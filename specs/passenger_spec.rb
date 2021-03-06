require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end # Describe instantiation


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, date: "2016-08-08", rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end # Describe trips property

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, date: "2016-08-08", rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end # Describe get_drivers method


  describe "#total_money" do
    before do
      @start_time = Time.parse("2016-08-21T08:51:00+00:00")
    end
    it "returns total spent in float" do
      pass = RideShare::Passenger.new({
        id: 89,
        trips: [
          RideShare::Trip.new({rating:3, cost:27, start_time: @start_time, end_time: @start_time + 25 * 60}),
          RideShare::Trip.new({rating:3,cost:14.87, start_time: @start_time, end_time: @start_time + 25 * 60}),
          RideShare::Trip.new({rating:3,cost:4.95, start_time: @start_time, end_time: @start_time + 25 * 60})
        ]
        })
      expected_total = 46.82
      result = pass.total_money
      result.must_equal expected_total
    end

    it "returns zero if passanger has no trips" do
      pass = RideShare::Passenger.new({id: 89})
      expected_total = 0
      result = pass.total_money
      result.must_equal expected_total
    end

    it "accurately ignores trips in progress" do
      pass = RideShare::Passenger.new({
        id: 89,
        trips: [
          RideShare::Trip.new({rating:3, cost:27, start_time: @start_time, end_time: @start_time + 25 * 60}),
          RideShare::Trip.new({rating:3,cost:14.87, start_time: @start_time, end_time: @start_time + 25 * 60}),
          RideShare::Trip.new({start_time: @start_time})
        ]
      })
      expected_total = 41.87
      result = pass.total_money
      result.must_equal expected_total
    end

  end # Describe total_money

  describe "#total_time" do

    it "returns total spent in float" do
      pass = RideShare::Passenger.new({
        id: 89,
        trips: [
          RideShare::Trip.new({
            rating:3,
            cost:27,
            start_time: Time.parse("2016-02-16T12:45:00+00:00"),
            end_time: Time.parse("2016-02-16T12:45:00+00:00") + 25 * 60
            }),
          RideShare::Trip.new({
            rating:3,
            cost:27,
            start_time: Time.parse("2016-02-16T12:45:00+00:00"),
            end_time: Time.parse("2016-02-16T12:45:00+00:00") + 15 * 60
            }),
          RideShare::Trip.new({
            rating:3,
            cost:27,
            start_time: Time.parse("2016-02-16T12:45:00+00:00"),
            end_time: Time.parse("2016-02-16T12:45:00+00:00") + 42 * 60
            })
        ]
        })
      expected_total = 4920
      result = pass.total_time
      result.must_equal expected_total
    end

    it "returns zero if passanger has no trips" do
      pass = RideShare::Passenger.new({id: 89})
      expected_total = 0
      result = pass.total_time
      result.must_equal expected_total
    end

    it "accurately ignores trips in progress" do
      start_time = Time.parse("2016-02-16T12:45:00+00:00")
      pass = RideShare::Passenger.new({
        id: 89,
        trips: [
          RideShare::Trip.new({rating:3, cost:27, start_time: start_time, end_time: start_time + 25 * 60}),
          RideShare::Trip.new({rating:3,cost:14.87, start_time: start_time, end_time: start_time + 25 * 60}),
          RideShare::Trip.new({start_time: start_time})
        ]
      })
      expected_total = 3000
      result = pass.total_time
      result.must_equal expected_total
    end

  end # Describe total_spent


end # Describe Passanger Class
