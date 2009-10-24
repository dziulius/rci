require 'blueprints'
Blueprints.load(:filename => 'db/blueprint.rb', :delete_policy => :truncate)
include Blueprints::Helper
build :tasks, :department_belongings