require File.dirname(__FILE__) + "/../spec_helper"

describe DatesHelper do
  it "should return correct combo box for date selection" do
    helper.compact_month_select(:date, Date.new(2009, 11), Date.new(2009, 10), Date.new(2010, 1)).should have_tag('select#date[name=date]') do
      with_tag 'option[value=?]', '2009/10', :text => '2009-October'
      with_tag 'option[value=?][selected=selected]', '2009/11', :text => '2009-November'
      with_tag 'option[value=?]', '2009/12', :text => '2009-December'
      with_tag 'option[value=?]', '2010/01', :text => '2010-January'
    end
  end

  it "should return empty combo box if dates were not specified" do
    helper.compact_month_select(:date, nil, nil, nil).should have_tag('select#date[name=date]')
  end
end