require 'test_helper'

class LockerTest < ActiveSupport::TestCase
  test "A locker can have a rental" do
    locker = Locker.create
    rental_1 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    assert locker.rentals.map(&:id).include?(rental_1.id)
  end

  test "A locker can have old rentals and current rentals" do
    locker = Locker.create
    rental_1 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    rental_1.complete!
    rental_2 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    assert locker.rentals.count == 2
  end

  test "A locker CANT have two active rentals" do
    locker = Locker.create
    rental_1 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    rental_2 = locker.rentals.create(last_name: "G", phone_number: "123", terms: true)
    assert locker.rentals.count == 1
  end

  test "locker#set_occupied changes occupied to true" do
    locker = Locker.create
    assert !locker.occupied?
    locker.set_occupied
    assert locker.occupied?
  end

  test "locker#set_unoccupied changes occupied to false" do
    locker = Locker.create(occupied: true)
    assert locker.occupied?
    locker.set_unoccupied
    assert !locker.occupied?
  end

  test "Locker#occupied_count returns the count of all occupied lockers" do
    Locker.create(occupied: true)
    Locker.create(occupied: true)
    Locker.create(occupied: true)
    Locker.create(occupied: false)
    assert Locker.occupied_count == 3
  end

  test "Locker#open_count returns the count of all open lockers" do
    Locker.create(occupied: true)
    Locker.create(occupied: false)
    Locker.create(occupied: true)
    Locker.create(occupied: false)
    assert Locker.occupied_count == 2
  end


  test "locker#current_rental returns the current rental on the locker" do
    locker = Locker.create
    rental_1 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    rental_1.complete!
    rental_2 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)

    assert locker.current_rental == rental_2
  end

  test "locker#previous_rentals returns the all past rentals locker" do
    locker = Locker.create
    rental_1 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    rental_1.complete!
    rental_2 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)
    rental_2.complete!
    rental_3 = locker.rentals.create(last_name: "G", phone_number: "111", terms: true)

    assert locker.previous_rentals == [rental_1, rental_2]
  end

  test "locker#text_status returns 'In Use' if locker is occupied" do
    locker = Locker.create(occupied: true)
    assert locker.text_status == "In Use"
  end

  test "locker#text_status returns 'Open' if locker is open" do
    locker = Locker.create
    assert locker.text_status == "Open"
  end

end
