require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  it "should show info about field correctly" do
    build :admin
    helper.field_list_item(@admin, :name).should have_tag('li', :text => "Name#{@admin.name}") do
      with_tag('span.header', :text => 'Name') 
    end
  end
end