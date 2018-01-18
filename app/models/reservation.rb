class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  # validates :reservation_validator, acceptance: true

  private



  #validates checkin doesn't overlap with another reservation
  def conflict?
    conflict = self.listing.reservations.find do |rez|
      (rez.checkin < self.checkin) && (rez.checkout > self.checkin)
    end
    conflict ? true : false
  end

  def reservation_validator
    if self.conflict?
      errors.add(:checkin, 'Checkin conflict yo')
    elsif self.checkin < self.checkout
      errors.add(:checkin, 'Can\'t  check out before u check in gurllll')
    elsif self.checkin != self.checkout
      errors.add(:checkin, 'Can\'t checkin and out at the same time u dingus')
    elsif self.guest_id != self.listing.host_id #validates host and guest are different
      errors.add(:guest_id, "can\'t host yourself biotch")
    end
  end




end
