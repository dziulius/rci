require 'spec_helper'

describe BudgetsController do
  before do
    build :admin
    login @admin
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
      response.should render_template('budgets/index')
      assigns(:budgets).should == Budget.all
    end
  end
end
