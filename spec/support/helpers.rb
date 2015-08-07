module Helpers

  def stub_basic_auth
    expect(controller).to receive(:basic_auth).and_return(true)
  end

  def seed_lockers
    Locker.create(row: 0, column: 1)
    Locker.create(row: 0, column: 2)
    Locker.create(row: 0, column: 3)
    Locker.create(row: 0, column: 4)
    Locker.create(row: 0, column: 5)
  end

  def stub_lr_good_drop_off
    LockerRoomClient.any_instance.stub(:ping_drop_off).and_return(true)
  end

  def stub_lr_bad_drop_off
    LockerRoomClient.any_instance.stub(:ping_drop_off).and_return(false)
  end

  def stub_lr_good_retrieval
    LockerRoomClient.any_instance.stub(:ping_retrieval).and_return(true)
  end

  def stub_lr_bad_retrieval
    LockerRoomClient.any_instance.stub(:ping_retrieval).and_return(false)
  end
end
