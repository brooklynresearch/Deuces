RSpec.describe Locker, type: :model do
  context "Lockers having rentals:" do

    it "A locker can have a rental" do
      locker = Locker.create
      rental_1 = locker.rentals.create(last_name: "G", phone_number: "1111", terms: true)
      assert locker.rentals.map(&:id).include?(rental_1.id)
    end

    it "A locker can have old rentals and current rentals" do
      locker = Locker.create
      rental_1 = locker.rentals.create(last_name: "G", phone_number: "2222", terms: true)
      rental_1.complete!
      rental_2 = locker.rentals.create(last_name: "G", phone_number: "4444", terms: true)
      assert locker.rentals.count == 2
    end

    it "A locker CANT have two active rentals" do
      locker = Locker.create
      rental_1 = locker.rentals.create(last_name: "G", phone_number: "1111", terms: true)
      rental_2 = locker.rentals.create(last_name: "G", phone_number: "2222", terms: true)
      assert locker.rentals.count == 1
    end

  end

  context "Locker methods" do

    it "locker#set_occupied changes occupied to true" do
      locker = Locker.create
      assert !locker.occupied?
      locker.set_occupied
      assert locker.occupied?
    end

    it "locker#set_unoccupied changes occupied to false" do
      locker = Locker.create(occupied: true)
      assert locker.occupied?
      locker.set_unoccupied
      assert !locker.occupied?
    end

    it "Locker#occupied_count returns the count of all occupied lockers" do
      Locker.create(occupied: true)
      Locker.create(occupied: true)
      Locker.create(occupied: true)
      Locker.create(occupied: false)
      assert Locker.occupied_count == 3
    end

    it "Locker#open_count returns the count of all open lockers" do
      Locker.create(occupied: true)
      Locker.create(occupied: false)
      Locker.create(occupied: true)
      Locker.create(occupied: false)
      assert Locker.occupied_count == 2
    end


    it "locker#current_rental returns the current rental on the locker" do
      locker = Locker.create
      rental_1 = locker.rentals.create(last_name: "G", phone_number: "1111", terms: true)
      rental_1.complete!
      rental_2 = locker.rentals.create(last_name: "G", phone_number: "3333", terms: true)

      assert locker.current_rental == rental_2
    end

    it "locker#previous_rentals returns the all past rentals locker" do
      locker = Locker.create
      rental_1 = locker.rentals.create(last_name: "G", phone_number: "1111", terms: true)
      rental_1.complete!
      rental_2 = locker.rentals.create(last_name: "G", phone_number: "2222", terms: true)
      rental_2.complete!
      rental_3 = locker.rentals.create(last_name: "G", phone_number: "3333", terms: true)

      assert locker.previous_rentals == [rental_1, rental_2]
    end

    it "locker#text_status returns 'In Use' if locker is occupied" do
      locker = Locker.create(occupied: true)
      assert locker.text_status == "In Use"
    end

    it "locker#text_status returns 'Open' if locker is open" do
      locker = Locker.create
      assert locker.text_status == "Open"
    end

  end
end
