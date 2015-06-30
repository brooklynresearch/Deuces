class Rental < ActiveRecord::Base
  belongs_to :locker
  validates_presence_of :last_name, :pin, :locker_id
  after_create :set_locker_occupied

  def set_locker_occupied
    locker.set_occupied
  end

  def complete!
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
  end
end
