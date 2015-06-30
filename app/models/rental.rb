class Rental < ActiveRecord::Base
  belongs_to :locker
  validates_presence_of :last_name, :pin, :locker_id

  def assign_locker!
    locker = Locker.all_open.sample
    if locker
      update_attribute(:locker_id, locker.id)
      locker.set_occupied
    end
  end

  def complete!
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
  end
end
