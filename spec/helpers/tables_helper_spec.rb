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

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') do
        with_tag('th', 'Name')
        with_tag('th', 'Leader')
      end
      with_tag("tr.project#row_project_#{@psi.id}") do
        with_tag('td', :text => 'PSI')
        with_tag('td', :text => 'project')
      end
    end
  end

  it "should allow creating table for collection of models without block" do
    build :psi
    helper.table_for(Project, [@psi], :name)

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') { with_tag('th', 'Name') }
      with_tag('tr') { with_tag('td', :text => 'PSI') }
    end
  end

  it "should automatically add content for table bottom" do
    helper.content_for(:table_bottom) do
      'table bottom'
    end

    helper.table_for(Project, [])
    helper.output_buffer.should have_tag('table', :text => 'table bottom')
  end

  it "should allow creating a table with totals row" do
    build :admin, :andrius
    helper.table_with_totals_for(User, [@admin, @andrius], :name, :id)

    helper.output_buffer.should have_tag('table') do
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

      with_tag('tr.total-row') do
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

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') do
        with_tag('th', :text => 'Total:')
        with_tag('td', :text => "@#{@admin.id + @andrius.id}")
      end
    end
  end

  it "should allow using formatters" do
    build :andrius
    helper.table_for(User, [@andrius], helper.linked(:name))

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') { with_tag('th', :text => 'Name') }

      with_tag('tr') do
        with_tag('td') do
          with_tag('a[href=?]', "/users/#{@andrius.to_param}", :text => @andrius.name)
        end
      end
    end
  end

  it "should allow using formatters with table_with_totals" do
    build :andrius, :admin
    @andrius.stubs(:id2).returns(@andrius.id * 2)
    @admin.stubs(:id2).returns(@admin.id * 2)
    helper.table_with_totals_for(User, [@admin, @andrius], :name, :id2, helper.with_percent(:id, :id2))

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') do
        with_tag('th', 'Name')
        with_tag('th', 'Id')
        with_tag('th', 'Id2')
      end

      with_tag('tr') do
        with_tag('td', :text => 'admin')
        with_tag('td', :text => @admin.id2.to_s)
        with_tag('td', :text => "#{@admin.id} (50.000%)")
      end

      with_tag('tr') do
        with_tag('td', :text => 'andrius')
        with_tag('td', :text => @andrius.id2.to_s)
        with_tag('td', :text => "#{@andrius.id} (50.000%)")
      end

      with_tag('tr') do
        with_tag('th', :text => 'Total:')
        with_tag('td', :text => (@andrius.id2 + @admin.id2).to_s)
        with_tag('td', :text => "#{@andrius.id + @admin.id} (50.000%)")
      end
    end
  end

  it "should not add nil column headers" do
    build :andrius
    helper.output_buffer = ''
    helper.table_for(User, [@andrius], helper.tail_link('show'))

    helper.output_buffer.should have_tag('table') do
      with_tag('tr') { without_tag('th') }

      with_tag('tr') do
        with_tag('td') do
          with_tag('a')
        end
      end
    end
  end
end
