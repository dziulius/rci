module Authentication
  require "authlogic/test_case"

  def login(user)
    activate_authlogic
    UserSession.create!(user)
  end
end