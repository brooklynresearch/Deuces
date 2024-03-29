RSpec.describe Rental, type: :model do
  context "Rentals:" do

    it "Rental can be associated with a locker" do
      locker = Locker.create
      rental = Rental.create(last_name: "Glass", locker_id: locker.id, terms: true)

      assert rental.locker == locker
    end

    it "Rental isnt valid without a phone number" do
      locker = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker.id, terms: true)
      assert !rental_1.valid?

      rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222", terms: true)
      assert rental_2.valid?
    end

    it "Rental isnt valid without a last name" do
      locker = Locker.create
      rental_1 = Rental.create(locker_id: locker.id, phone_number: "2222", terms: true)
      assert !rental_1.valid?

      rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222", terms: true)
      assert rental_2.valid?
    end

    it "Rental isnt valid without a locker" do
      locker = Locker.create
      rental_1 = Rental.create(phone_number: "2222", last_name: "Glass", terms: true)
      assert !rental_1.valid?

      rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222", terms: true)
      assert rental_2.valid?
    end

    it "Rental isnt valid without an UNOCCUPIED locker" do
      locker_1 = Locker.create(occupied: true)
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2222", terms: true)
      assert !rental_1.valid?

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "2222", terms: true)
      assert rental_2.valid?
    end

    it "Rental isnt valid without terms == true" do
      locker_1 = Locker.create(occupied: true)
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2222", terms: false)
      assert !rental_1.valid?

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "2222", terms: nil)
      assert !rental_2.valid?

      locker_3 = Locker.create
      rental_3 = Rental.create(last_name: "Glass", locker_id: locker_3.id, phone_number: "2222", terms: true)
      assert rental_3.valid?
    end

    it "Rental isnt valid with a non numeric phone number" do
      locker = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "MF32323", terms: true)
      assert !rental_1.valid?

      rental_2 = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "2222", terms: true)
      assert rental_2.valid?
    end

    it "Rental sets its locker to occupied after created (via Rental#set_locker_occupied)" do
      locker = Locker.create
      assert !locker.occupied

      Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "3223", terms: true)
      locker = locker.reload
      assert locker.occupied
    end

    it "Rental#complete! updates current: false, end_time: DateTime.now and sets locker unoccupied" do
      locker = Locker.create
      rental = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "3223", terms: true)
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

    it "Rental generates a hashed_id after creation" do
      locker = Locker.create
      rental = Rental.create(last_name: "Glass", locker_id: locker.id, phone_number: "1234", terms: true)
      assert rental.hashed_id.present?
      assert rental.hashed_id.is_a?(String)
      assert rental.hashed_id.length == 8
    end

    it "CAN store a phone with the same number, but different name as a current rental" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2211", terms: true)
      assert rental_1.valid?

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "Lu", locker_id: locker_2.id, phone_number: "2211", terms: true)
      assert rental_2.valid?
    end

    it "CANNOT store a phone with the same number, and same name as a current rental" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2211", terms: true)
      assert rental_1.valid?

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "GLASS", locker_id: locker_2.id, phone_number: "2211", terms: true)
      assert !rental_2.valid?
    end

    it "CAN store a phone with the same name & number as a old rental" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1234", terms: true)

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "1234", terms: true)
      assert !rental_2.valid?

      rental_1.complete!
      assert rental_2.valid?
    end

    it "CAN store a phone with the same name & number as a old rental IF name == 'DISABLED_LOCKER' " do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "DISABLED_LOCKER", locker_id: locker_1.id, phone_number: "1234", terms: true)

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "DISABLED_LOCKER", locker_id: locker_2.id, phone_number: "1234", terms: true)
      assert rental_1.valid?
      assert rental_2.valid?
    end

    it "Can COMPLETE a rental if the phone is the same number as a old rental (ensure validation only on create, not update)" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "4444", terms: true)
      rental_1.complete!

      locker_2 = Locker.create
      rental_2 = Rental.create(last_name: "Glass", locker_id: locker_2.id, phone_number: "2222", terms: true)
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

    it "Cannot double assign a locker" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "1111", terms: true)
      rental_2 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "2222", terms: true)

      assert rental_1.valid?
      assert !rental_2.valid?

    end
  end

  context "upcasing last_name" do
    it "rentals are stored with all up case" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "3333", terms: true)

      assert rental_1.last_name ==  "GLASS"
    end
  end

  context ".find_current" do
    it "finds a current rental" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "3123", terms: true)

      rental = Rental.find_current("GLASS", "3123")
      assert rental.id == rental_1.id
    end

    it "is case insensitive" do
      locker_1 = Locker.create
      rental_1 = Rental.create(last_name: "Glass", locker_id: locker_1.id, phone_number: "3132", terms: true)

      rental = Rental.find_current("GlaSs", "3132")
      assert rental.id == rental_1.id
    end

  end
end
