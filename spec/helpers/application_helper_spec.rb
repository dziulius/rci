require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  it "should show info about field correctly" do
    build :admin
    helper.field_list_item(@admin, :name).should have_tag('li', :text => "Name#{@admin.name}") do
      with_tag('span.header', :text => 'Name')
    end
  end

  it "should show info about field even if additional attribute is added" do
    build :psi
    helper.field_list_item(@psi, :leader, :name).should have_tag('li', :text => "Leader#{@andrius.name}") do
      with_tag('span.header', :text => 'Leader')
    end
  end

  it "return nil if any attribute returns nil" do
    build :psi
    helper.field_list_item(@psi, :leader, :department, :name).should == nil
  end

  describe 'tabs' do
    before do
      helper.expects(:t).with(:first, {:scope => 'tabs'}).returns('First')
      helper.expects(:t).with(:second, {:scope => 'tabs'}).returns('Second')
      helper.expects(:t).with('tabs.loading').returns('Loading...')
      helper.expects(:url_for).with(:tab => :first, :format => 'js').returns('/url?tab=first')
      helper.expects(:url_for).with(:tab => :second, :format => 'js').returns('/url?tab=second')
      helper.output_buffer = ''
    end

    it "should allow generating surrounding tabs" do
      helper.instance_variable_set(:@tabs, [:first, :second])
      tabs = helper.tabs

      tabs.should have_tag("div#tabs") do
        with_tag('ul') do
          with_tag('li') { with_tag('a[href=?]', '/url?tab=first', :text => 'First') }
          with_tag('li') { with_tag('a[href=?]', '/url?tab=second', :text => 'Second') }
        end
      end

      tabs.should have_tag("script[type='text/javascript']", :text => "\n//\ntabs('Loading...')\n//\n")
    end
  end
end
