class Task < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :status, inclusion: { in: statuses.keys }
  validates :due_date, presence: true

  validate :due_date_not_in_past

  private

  def due_date_not_in_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "cannot be in the past")
    end
  end
end
