RSpec.describe RentalsController do

  before(:each) do
    seed_lockers
  end

  describe 'GET #new' do
    context 'new rental page' do
      it 'returns a 200' do
        get :new, device_id: 1
        expect(response.status).to eq(200)
      end
    end

    context "sets @tablet based on params[:tablet]" do
      it "sets to true with params[:tablet] present" do
        get :new, device_id: 1, tablet: "t"
        expect(assigns(:tablet)).to eq(true)
      end

      it "sets to false if params[:tablet] not present" do
        get :new, device_id: 1
        expect(assigns(:tablet)).to eq(false)
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
                                             phone_number: "1111"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Terms must be approved to store your device"
      end

      it 'redirects when not provided valid info for a rental (no name)' do
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "2222"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Last name can't be blank"
      end

      it 'redirects when not provided valid info for a rental (bad phone)' do
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "NOT A PHONE",
                                             last_name: "Glass"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Phone number must be 4 digits"
      end

      it 'redirects when not provided valid info for a rental (> 4 digit phone number)' do
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "12345",
                                             last_name: "Glass"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Phone number must be 4 digits"
      end


      it 'redirects without creating if all LARGE lockers are occupied and storing a tablet' do
        Locker.where(large:true).each {|l| l.set_occupied}
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "1232",
                                             last_name: "Glass",
                                             large: "true"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Sorry, all lockers are currently occupied!"
      end

      it 'redirects without creating if all SMALL lockers are occupied and storing a phone' do
        Locker.where(large:false).each {|l| l.set_occupied}
        post :create, device_id: 1, rental: {terms: true,
                                             phone_number: "1234",
                                             last_name: "Glass",
                                             large: "false"}
        expect(response).to redirect_to new_rental_path
        expect(flash[:notice]).to eq "Sorry, all lockers are currently occupied!"
      end
    end

    context "creating a rental" do
      context "When getting a GOOD response from the locker room" do
        it "creates a rental and redirects to rental show" do
          stub_lr_good_drop_off
          count = Rental.count
          post :create, device_id: 1, rental: {terms: true,
                                                 phone_number: "1234",
                                                 last_name: "Glass",
                                                 large: "true"}
          expect(response).to redirect_to rental_path(assigns(:rental))
          expect(Rental.count).to eq(count + 1)
        end
        it "stores a large device in a large locker" do
          stub_lr_good_drop_off
          count = Rental.count
          post :create, device_id: 1, rental: {terms: true,
                                                 phone_number: "1234",
                                                 last_name: "Glass",
                                                 large: "true"}
          expect(response).to redirect_to rental_path(assigns(:rental))
          expect(Rental.count).to eq(count + 1)
          expect(Rental.last.locker.large).to eq(true)
        end

        it "stores a small device in a small locker" do
          stub_lr_good_drop_off
          count = Rental.count
          post :create, device_id: 1, rental: {terms: true,
                                                 phone_number: "1234",
                                                 last_name: "Glass",
                                                 large: "false"}
          expect(response).to redirect_to rental_path(assigns(:rental))
          expect(Rental.count).to eq(count + 1)
          expect(Rental.last.locker.large).to eq(false)
        end

        it "stores a small device even if all large devices are occupied" do
          stub_lr_good_drop_off
          Locker.where(large: true).each(&:set_occupied)
          count = Rental.count
          post :create, device_id: 1, rental: {terms: true,
                                                 phone_number: "1234",
                                                 last_name: "Glass",
                                                 large: "false"}
          expect(response).to redirect_to rental_path(assigns(:rental))
          expect(Rental.count).to eq(count + 1)
          expect(Rental.last.locker.large).to eq(false)
        end

        it "stores a large device even if all small devices are occupied" do
          stub_lr_good_drop_off
          Locker.where(large: false).each(&:set_occupied)
          count = Rental.count
          post :create, device_id: 1, rental: {terms: true,
                                                 phone_number: "1234",
                                                 last_name: "Glass",
                                                 large: "true"}
          expect(response).to redirect_to rental_path(assigns(:rental))
          expect(Rental.count).to eq(count + 1)
          expect(Rental.last.locker.large).to eq(true)
        end
      end

      it "When getting a BAD response from the locker room, doesnt create a rental and redirects to rental#new" do
        stub_lr_bad_drop_off
        count = Rental.count
        post :create, device_id: 1, rental: {terms: true,
                                               phone_number: "1234",
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
                                             phone_number: "1234"}
        expect(response).to redirect_to retrieve_rentals_path
        expect(flash[:notice]).to eq "Sorry, we couldn't find a current rental with that information.  Please try again."
      end
    end

    context "when finding a rental" do

      it 'completes the rental with good response from the LR client' do
        stub_lr_good_retrieval

        locker = Locker.create(row: 1, column: 1)
        rental = Rental.create(locker: locker, last_name: "Glass",
                               phone_number: "1234", terms: true)
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true

        put :complete, device_id: 1, rental: { last_name: "Glass",
                                               phone_number: "1234"}

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
                               phone_number: "1234", terms: true)
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true

        put :complete, device_id: 1, rental: { last_name: "Glass",
                                               phone_number: "1234"}

        rental.reload
        locker.reload

        expect(response).to redirect_to new_rental_path
        expect(rental.current).to eq true
        expect(locker.occupied).to eq true
      end
    end
  end

end
