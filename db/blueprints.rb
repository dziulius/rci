blueprint :users do
  @admin = User.blueprint(:name => 'admin', :email => 'admin@example.com', :password => 'secret', :password_confirmation => 'secret')
end