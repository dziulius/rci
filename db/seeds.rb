require 'blueprints'
Blueprints.load(:filename => 'db/blueprints.rb')
include Blueprints::Helper
build :users