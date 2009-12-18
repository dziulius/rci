require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminMailer do
  before do
    @users = [{ :name => "Johnny B. Goode", :password => "0.1234567890" },
              { :name => "James Bond", :password => "0.5432101234" }]
    ActionMailer::Base.deliveries = []
    @email = AdminMailer.create_password_list(@users)
  end

  describe "generated password list email" do

    it "should contain user names" do
      @users.each { |user| @email.body.should =~ /#{user[:name]}/ }
    end

    it "should contain user passwords" do
      @users.each { |user| @email.body.should =~ /#{user[:password]}/ }
    end
  end

end
