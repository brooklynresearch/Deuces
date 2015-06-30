class Rental < ActiveRecord::Base
  belongs_to :locker

  validates_uniqueness_of :phone_number, scope: :current
  validates_presence_of :last_name, :phone_number, :locker_id
  validate :phone_digits_only
  validate :locker_unoccupied, on: :create

  after_create :set_locker_occupied
  after_create :assign_hashed_id

  def set_locker_occupied
    locker.set_occupied
  end

  def complete
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
  end

private
  def phone_digits_only
    unless phone_number.to_i.to_s == phone_number
      errors.add(:phone_number, "must be only digits")
    end
  end

  def locker_unoccupied
    if self.locker.occupied?
      errors.add(:locker, "All lockers are currently occupied")
    end
  end

  def assign_hashed_id
    generated_hash = rand(36**8).to_s(36)
    assign_hashed_id if Rental.exists?(hashed_id: generated_hash)
    update_attribute(:hashed_id, generated_hash)
  end

end
