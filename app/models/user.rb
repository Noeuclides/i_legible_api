class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :lessons, dependent: :destroy
  has_many :vocabulary_entries, dependent: :destroy

  def jwt_payload
    super.merge('sub' => id)
  end

  def self.find_for_jwt_authentication(sub)
    find_by(id: sub)
  end

  def self.jwt_revoked?(payload, user)
    # Check if the token has been revoked
    user&.jti != payload['jti']
  end

  def self.revoke_jwt(payload, user)
    # Mark the token as revoked
    user.update_column(:jti, nil) if user
  end
end
