require 'monkey_patches/flipper/gates/percentage_of_actors'
require 'flipper/adapters/active_record'

adapter = Flipper::Adapters::ActiveRecord.new
$flipper = Flipper.new(adapter)
