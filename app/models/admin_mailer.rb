class AdminMailer < ActionMailer::Base
  
  def password_list(users)
    subject    'RCi password list of newly created users'
    recipients 'rci_mail@yahoo.com'
    from       'rci@somewhere'
    sent_on    Time.now
    body       :users => users
  end

end
