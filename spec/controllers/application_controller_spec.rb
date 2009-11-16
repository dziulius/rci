require File.dirname(__FILE__) + "/../spec_helper"

describe ApplicationController do
  describe 'tabs' do
    before do
      @controller = ApplicationController.new
    end

    it "should allow rendering tabs" do
      @controller.expects(:render).with(:partial => 'second')
      @controller.stubs(:params).returns(:tab => 'second')

      @controller.send(:render_js_tabs, :first, :second).call
      @controller.instance_variable_get(:@tabs).should == [:first, :second]
    end

    it "should render first tab is invalid tab is passed" do
      @controller.expects(:render).with(:partial => 'first')
      @controller.stubs(:params).returns(:tab => 'xxx')

      @controller.send(:render_js_tabs, :first, :second).call
    end

    it "should render correct tab if correct tab is passed" do
      @controller.expects(:respond_to).yields(responder = mock)
      responder.expects(:html)
      responder.expects(:js).yields
      @controller.expects(:render_js_tabs).with(:first, :second)

      @controller.send(:render_tabs, :first, :second)
    end
  end
end