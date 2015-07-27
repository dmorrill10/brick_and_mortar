require_relative 'support/spec_helper'

require_relative '../lib/mortar'

def test_git_https_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar.git'
end

def test_git_ssh_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.url.must_equal 'git@github.com:dmorrill10/mortar.git'
end

describe Mortar do
  describe 'parses Brickfile.yml configuration with' do
    describe 'git https' do
      it 'from string' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location:
    method: git
    url: https://github.com/dmorrill10/mortar.git
  END
        test_git_https_config Mortar.parse(test_brickfile_config)
      end

      it 'from file' do
        test_git_https_config(
          Mortar.parse_file(
            File.expand_path(
              '../support/test_files/git_https_brickfile.yml',
              __FILE__
            )
          )
        )
      end
    end

    describe 'git ssh' do
      it 'from string' do
        test_brickfile_config = <<-END
  -
    name: mortar
    version: 0.0.1
    location:
      method: git
      url: git@github.com:dmorrill10/mortar.git
    END
        test_git_ssh_config Mortar.parse(test_brickfile_config)
      end

      it 'from file' do
        test_git_ssh_config(
          Mortar.parse_file(
            File.expand_path(
              '../support/test_files/git_ssh_brickfile.yml',
              __FILE__
            )
          )
        )
      end
    end

    # @todo Copy the above tests, but for svn, url, hg, and local project configurations (see support/test_files for example configurations)

    # @todo A little more has to be done for local project, since the path to the local project might have to be relative to the brickfile, so I can do that one
  end
end
