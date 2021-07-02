Role.where(name: Role::ROLE_TEACHER).first_or_create
Role.where(name: Role::ROLE_STUDENT).first_or_create

unless User.first
  user = User.create!(
    email: 'teacher@example.com',
    name: 'Admin',
    password: '12345678',
    password_confirmation: '12345678'
  )
  user.add_role(Role::ROLE_TEACHER)
end
