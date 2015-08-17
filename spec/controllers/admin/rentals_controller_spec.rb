RSpec.describe Admin::RentalsController do

  before(:each) do
    seed_lockers
    stub_admin_auth
  end

  context "POST #retrieve" do
    it "completes a rental successfully when getting a good response from lr client" do
      stub_lr_good_retrieval

      locker = Locker.create(row: 1, column: 1)
      rental = Rental.create(locker: locker, last_name: "Glass",
                             phone_number: "1234", terms: true)
      expect(rental.current).to eq true
      expect(locker.occupied).to eq true

      post :retrieve, device_id: 1, id: rental.id

      rental.reload
      locker.reload

      expect(response).to redirect_to rental_path(rental)
      expect(rental.current).to eq false
      expect(locker.occupied).to eq false
    end

    it "reverses the completion if bad response from lr client" do
      stub_lr_bad_retrieval

      locker = Locker.create(row: 1, column: 1)
      rental = Rental.create(locker: locker, last_name: "Glass",
                             phone_number: "1234", terms: true)
      expect(rental.current).to eq true
      expect(locker.occupied).to eq true

      post :retrieve, device_id: 1, id: rental.id

      rental.reload
      locker.reload

      expect(response).to redirect_to admin_rental_path(rental)
      expect(rental.current).to eq true
      expect(locker.occupied).to eq true
    end

  end
end
