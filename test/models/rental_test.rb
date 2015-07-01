require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  test "Rental can be associated with a locker" do
    locker = Locker.create
    rental = Rental.create(last_name: "Glass", locker_id: locker.id)

    assert rental.locker == locker
  end

  test "Rental isnt valid without a phone number" do
    locker = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker.id)
    assert !rental_1.valid?

    rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222")
    assert rental_2.valid?
  end

  test "Rental isnt valid without a last name" do
    locker = Locker.create
    rental_1 = Rental.create(locker_id: locker.id, phone_number: "2222")
    assert !rental_1.valid?

    rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222")
    assert rental_2.valid?
  end

  test "Rental isnt valid without a locker" do
    locker = Locker.create
    rental_1 = Rental.create(phone_number: "2222", last_name: "Glass")
    assert !rental_1.valid?

    rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222")
    assert rental_2.valid?
  end

  test "Rental isnt valid without an UNOCCUPIED locker" do
    locker_1 = Locker.create(occupied: true)
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2222")
    assert !rental_1.valid?

    locker_2 = Locker.create
    rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "2222")
    assert rental_2.valid?
  end

  test "Rental isnt valid with a non numeric phone number" do
    locker = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "MF32323")
    assert !rental_1.valid?

    rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222")
    assert rental_2.valid?
  end

  test "Rental sets its locker to occupied after created (via Rental#set_locker_occupied)" do
    locker = Locker.create
    assert !locker.occupied

    Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "32323")
    locker = locker.reload
    assert locker.occupied
  end

  test "Rental#complete! updates current: false, end_time: DateTime.now and sets locker unoccupied" do
    locker = Locker.create
    rental = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "32323")
    locker.reload
    assert locker.occupied
    assert rental.current
    assert rental.end_time.nil?

    rental.complete!
    locker.reload

    assert !locker.occupied
    assert !rental.current
    assert rental.end_time.present?
    assert rental.end_time.is_a?(ActiveSupport::TimeWithZone)
  end

  test "Rental generates a hashed_id after creation" do
    locker = Locker.create
    rental = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "32323")
    assert rental.hashed_id.present?
    assert rental.hashed_id.is_a?(String)
    assert rental.hashed_id.length == 8
  end

  test "CANNOT store a phone with the same number as a current rental" do
    locker_1 = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1112223333")
    assert rental_1.valid?

    locker_2 = Locker.create
    rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "1112223333")
    assert !rental_2.valid?
  end

  test "CAN store a phone with the same number as a old rental" do
    locker_1 = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1112223333")

    locker_2 = Locker.create
    rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "1112223333")
    assert !rental_2.valid?

    rental_1.complete!
    assert rental_2.valid?
  end

  test "Can COMPLETE a rental if the phone is the same number as a old rental (ensure validation only on create, not update)" do
    locker_1 = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1112223333")
    rental_1.complete!

    locker_2 = Locker.create
    rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "1112223333")
    locker_2.reload

    assert rental_2.current
    assert locker_2.occupied
    assert rental_2.end_time.nil?

    rental_2.complete!
    locker_2.reload

    assert !locker_2.occupied
    assert !rental_2.current
    assert rental_2.end_time.present?
    assert rental_2.end_time.is_a?(ActiveSupport::TimeWithZone)
  end

  test "Cannot double assign a locker" do
    locker_1 = Locker.create
    rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1112223333")
    rental_2 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "9998887777")

    assert rental_1.valid?
    assert !rental_2.valid?

  end
end
