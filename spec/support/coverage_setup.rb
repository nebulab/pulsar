require 'simplecov'

# Save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.minimum_coverage 99
SimpleCov.minimum_coverage_by_file 90
SimpleCov.refuse_coverage_drop

if ENV['FEATURES_COVERAGE']
  SimpleCov.command_name 'features'

  # This is needed because otherwise SimpleCov will output some text at exit
  # and it will make most of the feature specs fail (that check the output).
  SimpleCov.at_exit do
    $stdout.reopen(File::NULL, 'w')
    $stdout.sync = true
    SimpleCov.result.format!
    $stdout = STDOUT
  end
end

SimpleCov.start do
  add_group 'Interactors', 'lib/pulsar/interactors'
  add_group 'Organizers', 'lib/pulsar/organizers'

  add_filter 'spec/*'
end
