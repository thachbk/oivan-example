class User < ApplicationRecord
  # include DeviseTokenAuth::Concerns::User
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  rolify

  validate :just_has_one_role


  def teachers?
    has_role?(Role::ROLE_TEACHER)
  end

  private
  
  def just_has_one_role
    errors.add(:roles, 'User can be assigned maximum of one role') unless roles&.size < 2
  end
end
