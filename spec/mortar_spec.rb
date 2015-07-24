require_relative 'support/spec_helper'

require_relative '../lib/mortar'

describe Mortar do

  it 'parses Brickfile.yml configuration with git https' do
    test_brickfile_config = <<-END
-
name: mortar
version: 0.0.1
location:
  method: git
  url: https://github.com/dmorrill10/mortar.git
END
    patient = Mortar.parse(test_brickfile_config)
    patient.name.must_equal 'mortar'
    patient.version.must_equal '0.0.1'
    patient.location.method.must_equal 'git'
    patient.location.url.must_equal 'https://github.com/dmorrill10/mortar.git'
  end
end