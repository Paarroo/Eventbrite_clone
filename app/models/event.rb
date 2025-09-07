# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :validated_by, class_name: 'User', optional: true
  has_many :attendances, dependent: :destroy
  has_many :payments, through: :attendances


  # Confirmed participants (paid or free)
  has_many :confirmed_attendances, -> { where(payment_status: [ 'succeeded', 'free' ]) },
           class_name: 'Attendance'

  has_many :confirmed_participants, through: :confirmed_attendances, source: :user

  # Participants pending payment
  has_many :pending_attendances, -> { where(payment_status: 'pending') },
           class_name: 'Attendance'

  has_many :pending_participants, through: :pending_attendances, source: :user

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :start_date, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validate :start_date_cannot_be_in_the_past

  # Validation scopes
  scope :pending, -> { where(validated: nil) }
  scope :validated, -> { where(validated: true) }
  scope :rejected, -> { where(validated: false) }
  scope :upcoming, -> { where('start_date > ?', Time.current) }
  scope :past, -> { where('start_date < ?', Time.current) }


  def validation_status
    case validated
    when true then "Validé"
    when false then "Refusé"
    else "En attente"
    end
  end

  def validated?
    validated == true
  end

  def rejected?
    validated == false
  end

  def pending?
    validated.nil?
  end


  # Number of confirmed participants
  def confirmed_participants_count
    attendances.where(payment_status: [ 'succeeded', 'free' ]).count
  end

  # Number of pending participants
  def pending_participants_count
    attendances.where(payment_status: 'pending').count
  end

  # Event revenue
  def total_revenue
    attendances.where(payment_status: 'succeeded').joins(:payment).sum('payments.amount') / 100.0
  end

  # Can the event be validated?
  def can_be_validated?
    pending? && start_date > Time.current
  end

  # Is it a free event?
  def free_event?
    price == 0
  end


  def full_price_with_currency
    "#{price}€"
  end

  def formatted_start_date
    start_date.strftime("%d/%m/%Y à %H:%M")
  end

  def duration_in_hours
    duration / 60.0
  end
  def participants_count
    confirmed_participants_count
  end

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Time.current
      errors.add(:start_date, "ne peut pas être dans le passé")
    end
  end
end
