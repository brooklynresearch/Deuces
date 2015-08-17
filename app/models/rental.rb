class Rental < ActiveRecord::Base
  belongs_to :locker

  validates_presence_of :last_name, :phone_number, :locker_id
  validate :ensure_phone_four_digits
  validate :ensure_locker_unoccupied, on: :create
  validate :ensure_phone_not_currently_stored, on: :create
  validate :ensure_terms, on: :create

  after_create :set_locker_occupied
  after_create :assign_hashed_id

  def self.find_current(last_name,phone_number)
    where(last_name:last_name.upcase, phone_number: phone_number, current: true).first
  end

  def set_locker_occupied
    locker.set_occupied
  end

  def complete!
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
  end

  def reverse_creation!
    locker.set_unoccupied
    destroy!
  end

  def reverse_completion!
    locker.set_occupied
    update_attributes(current: true, end_time: nil)
  end

  def last_name=(s)
    write_attribute(:last_name, s.to_s.upcase)
  end

private



  def ensure_phone_four_digits
    unless !!(phone_number =~ /^[0-9]+$/) && phone_number.length == 4
      errors.add(:phone_number, "must be 4 digits")
    end
  end

  def ensure_locker_unoccupied
    unless self.locker && !self.locker.occupied?
      errors.add(:locker, "All lockers are currently occupied")
    end
  end

  def ensure_phone_not_currently_stored
    if Rental.exists?(phone_number: phone_number, last_name: last_name, current: true)
      errors.add(:phone_number, "is currently stored in a locker")
    end
  end

  def ensure_terms
    unless terms
      errors.add(:terms, "must be approved to store your device")
    end
  end

  def assign_hashed_id
    generated_hash = rand(36**8).to_s(36)
    assign_hashed_id if Rental.exists?(hashed_id: generated_hash)
    update_attribute(:hashed_id, generated_hash)
  end

end
