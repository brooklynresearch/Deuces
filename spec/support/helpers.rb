module Helpers

  def seed_lockers
    Locker.create(row: 0, column: 1, large: false)
    Locker.create(row: 0, column: 2,large: false)
    Locker.create(row: 0, column: 3,large: false)
    Locker.create(row: 0, column: 4,large: true)
    Locker.create(row: 0, column: 5,large: true)
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
