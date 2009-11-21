require File.dirname(__FILE__) + "/../spec_helper"

describe TablesHelper do
  before do
    helper.output_buffer = ''
  end

  it "should allow creating table for collection of models" do
    build :psi
    helper.table_for(Project, [@psi], :name, :leader) do |project|
      [project.name, 'project']
    end

    helper.output_buffer.should have_tag('table[cellspacing=0][border=1]') do
      with_tag('tr') do
        with_tag('th', 'Name')
        with_tag('th', 'Leader')
      end
      with_tag('tr') do
        with_tag('td', :text => 'PSI')
        with_tag('td', :text => 'project')
      end
    end
  end

  it "should allow creating table for collection of models without block" do
    build :psi
    helper.table_for(Project, [@psi], :name)

    helper.output_buffer.should have_tag('table[cellspacing=0][border=1]') do
      with_tag('tr') { with_tag('th', 'Name') }
      with_tag('tr') { with_tag('td', :text => 'PSI') }
    end
  end

  it "should automatically add content for table bottom" do
    helper.content_for(:table_bottom) do
      'table bottom'
    end

    helper.table_for(Project, [])
    helper.output_buffer.should have_tag('table[cellspacing=0][border=1]', :text => 'table bottom')
  end

  it "should allow creating a table with totals row" do
    build :admin, :andrius
    helper.table_with_totals_for(User, [@admin, @andrius], :name, :id)

    helper.output_buffer.should have_tag('table[cellspacing=0][border=1]') do
      with_tag('tr') do
        with_tag('th', 'Name')
        with_tag('th', 'Id')
      end

      with_tag('tr') do
        with_tag('td', :text => 'admin')
        with_tag('td', :text => @admin.id.to_s)
      end

      with_tag('tr') do
        with_tag('td', :text => 'andrius')
        with_tag('td', :text => @andrius.id.to_s)
      end

      with_tag('tr') do
        with_tag('th', :text => 'Total:')
        with_tag('td', :text => (@admin.id + @andrius.id).to_s)
      end
    end
  end

  it "should allow creating custom total row" do
    build :admin, :andrius
    helper.table_with_totals_for(User, [@admin, @andrius], :name, :id) do |user|
      [user.name, "@#{user.id}"]
    end

    helper.output_buffer.should have_tag('table[cellspacing=0][border=1]') do
      with_tag('tr') do
        with_tag('th', :text => 'Total:')
        with_tag('td', :text => "@#{@admin.id + @andrius.id}")
      end
    end
  end
end