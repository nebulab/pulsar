require 'simplecov'

# Save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.minimum_coverage 99
SimpleCov.minimum_coverage_by_file 90
SimpleCov.refuse_coverage_drop

SimpleCov.start
