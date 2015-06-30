class Locker < ActiveRecord::Base
  has_many :rentals

  scope :all_occupied, -> { where(occupied: true)}
  scope :all_open, -> { where(occupied: false)}
  scope :ordered, -> { order(occupied: :desc, id: :asc)}

  def set_occupied
    update_attribute(:occupied, true)
  end

  def set_unoccupied
    update_attribute(:occupied, false)
  end

  def self.occupied_count
    all_occupied.count
  end

  def current_rental
    rentals.where(current: true).first
  end

  def previous_rentals
    rentals.where(current: false)
  end

  def text_status
    occupied? ? "Occupied" : "Open"
  end

  def occupied?
    occupied
  end
end
