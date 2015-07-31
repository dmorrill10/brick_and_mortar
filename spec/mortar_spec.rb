require_relative 'support/spec_helper'

require_relative '../lib/mortar'

def test_git_https_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.format.must_equal 'plain'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar.git'
end

def test_git_ssh_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.format.must_equal 'plain'
  patient[0].location.url.must_equal 'git@github.com:dmorrill10/mortar.git'
end

def test_zip_url_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'download'
  patient[0].location.format.must_equal 'zip'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar/archive/master.zip'
end

def test_tar_gz_url_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'download'
  patient[0].location.format.must_equal 'tar.gz'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar/archive/master.tar.gz'
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

      it 'where the method is not explicitly specified' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location: https://github.com/dmorrill10/mortar.git
END
        test_git_https_config Mortar.parse(test_brickfile_config)
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

      it 'where the method is not specified explicitly' do
        test_brickfile_config = <<-END
  -
    name: mortar
    version: 0.0.1
    location: git@github.com:dmorrill10/mortar.git
  END
        test_git_ssh_config Mortar.parse(test_brickfile_config)
      end
    end

    describe 'svn' do
      it 'from string' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location:
    method: svn
    url: https://github.com/dmorrill10/mortar
END
        patient = Mortar.parse(test_brickfile_config)
        patient.length.must_equal 1
        patient[0].name.must_equal 'mortar'
        patient[0].version.must_equal '0.0.1'
        patient[0].location.method.must_equal 'svn'
        patient[0].location.format.must_equal 'plain'
        patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar'
      end

      it 'from file' do
        patient = Mortar.parse_file(
          File.expand_path(
            '../support/test_files/svn_brickfile.yml',
            __FILE__
          )
        )
        patient.length.must_equal 1
        patient[0].name.must_equal 'mortar'
        patient[0].version.must_equal '0.0.1'
        patient[0].location.method.must_equal 'svn'
        patient[0].location.format.must_equal 'plain'
        patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar'
      end

      it 'where the method is not explicitly specified' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location: svn://github.com/dmorrill10/mortar
END
        patient = Mortar.parse(test_brickfile_config)
        patient.length.must_equal 1
        patient[0].name.must_equal 'mortar'
        patient[0].version.must_equal '0.0.1'
        patient[0].location.method.must_equal 'svn'
        patient[0].location.format.must_equal 'plain'
        patient[0].location.url.must_equal 'svn://github.com/dmorrill10/mortar'
      end
    end

    describe 'zip url' do
      it 'from string' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location: https://github.com/dmorrill10/mortar/archive/master.zip
END
        test_zip_url_config Mortar.parse(test_brickfile_config)
      end

      it 'from file' do
        test_zip_url_config(
          Mortar.parse_file(
            File.expand_path(
              '../support/test_files/url_brickfile.yml',
              __FILE__
            )
          )
        )
      end
    end

    describe 'tar.gz url' do
      it 'from string' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location: https://github.com/dmorrill10/mortar/archive/master.tar.gz
END
        test_tar_gz_url_config Mortar.parse(test_brickfile_config)
      end
    end

    # @todo Copy the above tests, but for hg and local project configurations (see support/test_files for example configurations)

    # @todo A little more has to be done for local project, since the path to the local project might have to be relative to the brickfile, so I can do that one
  end
end
