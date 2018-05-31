# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  birthday   :datetime
#  email      :string
#  first_name :string
#  last_name  :string
#  password   :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :bids
  has_many :lots, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :birthday, presence: true
  validate :validate_age
  def validate_age
    if birthday.present? && birthday > 21.years.ago
      errors.add :birthday, "age must be greater than 21"
    end
  end
end
