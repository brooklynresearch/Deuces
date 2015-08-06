class Rental < ActiveRecord::Base
  belongs_to :locker

  validates_presence_of :last_name, :phone_number, :locker_id
  validate :ensure_phone_digits_only
  validate :ensure_locker_unoccupied, on: :create
  validate :ensure_phone_not_currently_stored, on: :create
  validate :ensure_terms, on: :create

  after_create :set_locker_occupied
  after_create :assign_hashed_id
  after_create :ping_installation

  def set_locker_occupied
    locker.set_occupied
  end

  def complete!(device_id)
    update_attributes(current: false, end_time: DateTime.now)
    locker.set_unoccupied
    InstallationClient.new(self, device_id).ping_retrieval
  end

  def ping_installation
    InstallationClient.new(self, creation_device_id).ping_drop_off
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
