require 'blueprints'
Blueprints.load(:filename => 'db/blueprints.rb', :delete_policy => :truncate)
include Blueprints::Helper
build :tasks