#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

GALAXIES = {
  eu: { url: 'https://usegalaxy.eu', key: ENV.fetch('GALAXY_EU_KEY', nil) },
}

def test_workflow(workflow_file, galaxy_id)
  workflow_base = File.basename(workflow_file, '.ga')
  workflow_output_json = File.join(File.dirname(workflow_file), "#{workflow_base}.#{galaxy_id}.json")
  galaxy_url = GALAXIES[galaxy_id][:url]
  galaxy_user_key = GALAXIES[galaxy_id][:key]
  cmd = %(
    planemo --verbose test
      --galaxy_url #{galaxy_url}
      --galaxy_user_key #{galaxy_user_key}
      --no_shed_install
      --engine external_galaxy
      --polling_backoff 1
      --test_output_json #{workflow_output_json}
      #{workflow_file}
  ).split.map(&:strip).join(' ').strip
  puts cmd
  `#{cmd}`
end

test_workflow(ARGV[0], :eu)
