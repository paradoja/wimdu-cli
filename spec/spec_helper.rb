ENV['WIMDU_ENV'] ||= 'test'

require 'aruba/api'
require 'aruba/reporting'
require 'aruba/in_process'
require 'wimdu/runner'
require 'byebug'

RSpec.configure do |config|
  config.include Aruba::Api

  config.before(:each) do
    # On startup it might take a little longer for output to
    # arrive. On a really slow machine you might need to increase this
    # value even further.
    @aruba_io_wait_seconds = 1

    restore_env
    clean_current_dir
  end
end
