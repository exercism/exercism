require 'flipper/adapters/active_record'

adapter = Flipper::Adapters::ActiveRecord.new
$flipper = Flipper.new(adapter)
