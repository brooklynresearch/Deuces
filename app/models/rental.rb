class Rental < ActiveRecord::Base
  belongs_to :locker

  validates_presence_of :last_name, :phone_number, :locker_id
  validate :ensure_phone_digits_only
  validate :ensure_locker_unoccupied, on: :create
  validate :ensure_phone_not_currently_stored, on: :create

  after_create :set_locker_occupied
  after_create :assign_hashed_id

  def set_locker_occupied
    locker.set_occupied
  end

  def complete!
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
  end

private
  def ensure_phone_digits_only
    unless !!(phone_number =~ /^[0-9]+$/)
      errors.add(:phone_number, "must be only digits")
    end
  end

  def ensure_locker_unoccupied
    unless self.locker && !self.locker.occupied?
      errors.add(:locker, "All lockers are currently occupied")
    end
  end

  def ensure_phone_not_currently_stored
    if Rental.exists?(phone_number: phone_number, current: true)
      errors.add(:phone_number, "is currently stored in a locker")
    end
  end

  def assign_hashed_id
    generated_hash = rand(36**8).to_s(36)
    assign_hashed_id if Rental.exists?(hashed_id: generated_hash)
    update_attribute(:hashed_id, generated_hash)
  end

end
