RSpec.describe RentalsController do

  before(:each) do
    stub_basic_auth
    seed_lockers
  end

  describe 'GET #new' do
    context 'new rental page' do
      it 'returns a 200' do
        get :new, device_id: 1
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #hub' do
    context 'rental hub page' do
      it 'returns a 200' do
        get :hub, device_id: 1
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET #retrieve' do
    context 'rental retrieve page' do
      it 'returns a 200' do
        get :retrieve, device_id: 1
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST #create' do
    context 'not creating a rental' do
      it 'redirects when not provided valid info for a rental (no terms)' do
        post :create, device_id: 1, rental: {last_name: "Glass",
                                             phone_number: "1112223333"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Terms must be approved to store your device"
      end

      it 'redirects when not provided valid info for a rental (no name)' do
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "1112223333"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Last name can't be blank"
      end

      it 'redirects when not provided valid info for a rental (bad phone)' do
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "NOT A PHONE",
                                             last_name: "Glass"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Phone number must be only digits"
      end

      it 'redirects if all lockers are occupied' do
        Locker.all.each {|l| l.set_occupied}
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "NOT A PHONE",
                                             last_name: "Glass"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Sorry, all lockers are currently occupied!"
      end
    end

    context "creating a rental" do
      it "When getting a GOOD response from the locker room, creates a rental and redirects to rental show" do
        stub_lr_good_drop_off
        count = Rental.count
        post :create, device_id: 1, rental: {terms: true,
                                               phone_number: "11111",
                                               last_name: "Glass"}
        expect(response).to redirect_to rental_path(assigns(:rental))
        expect(Rental.count).to eq(count + 1)
      end

      it "When getting a BAD response from the locker room, doesnt create a rental and redirects to rental#new" do
        stub_lr_bad_drop_off
        count = Rental.count
        post :create, device_id: 1, rental: {terms: true,
                                               phone_number: "11111",
                                               last_name: "Glass"}
        expect(response).to redirect_to new_rental_path
        expect(Rental.count).to eq(count)
      end

    end
  end

  describe 'PUT #complete' do
    context 'not finding a rental' do
      it 'redirects when cannot find a rental in the db)' do
        put :complete, device_id: 1, rental: {last_name: "Glass",
                                             phone_number: "1112223333"}
        expect(response).to redirect_to retrieve_rentals_path
        expect(flash[:notice]).to eq "Sorry, we couldn't find a current rental with that information.  Please try again."
      end
    end

    context "when finding a rental" do

      it 'completes the rental with good response from the LR client' do
        stub_lr_good_retrieval

        locker = Locker.create(row: 1, column: 1)
        rental = Rental.create(locker: locker, last_name: "Glass",
                               phone_number: "1112223333", terms: true)
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true

        put :complete, device_id: 1, rental: { last_name: "Glass",
                                               phone_number: "1112223333"}

        rental.reload
        locker.reload

        expect(response).to redirect_to rental_path(rental)
        expect(rental.current).to eq false
        expect(locker.occupied).to eq false
      end

      it 'reverses the rental completion with bad response from the LR client' do
        stub_lr_bad_retrieval

        locker = Locker.create(row: 1, column: 1)
        rental = Rental.create(locker: locker, last_name: "Glass",
                               phone_number: "1112223333", terms: true)
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true

        put :complete, device_id: 1, rental: { last_name: "Glass",
                                               phone_number: "1112223333"}

        rental.reload
        locker.reload

        expect(response).to redirect_to new_rental_path
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true
      end
    end
  end

end
