require_relative 'support/spec_helper'

require_relative '../lib/mortar'

BRICK_STORE = File.expand_path('../.test_brick_store', __FILE__)

def test_git_https_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.format.must_equal 'plain'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar.git'
  File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
  patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
  patient[0].exists?.must_equal false
  patient[0].create!
  patient[0].exists?.must_equal true
  patient[0].destroy!
  patient[0].exists?.must_equal false
end

def test_git_ssh_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'git'
  patient[0].location.format.must_equal 'plain'
  patient[0].location.url.must_equal 'git@github.com:dmorrill10/mortar.git'
  File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
  patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
  patient[0].exists?.must_equal false
  patient[0].create!
  patient[0].exists?.must_equal true
  patient[0].destroy!
  patient[0].exists?.must_equal false
end

def test_zip_url_config(patient)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'download'
  patient[0].location.format.must_equal 'zip'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar/archive/master.zip'
  File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
  patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
  patient[0].exists?.must_equal false
  # @todo
  # patient[0].create!
  # patient[0].exists?.must_equal true
end

def test_tar_gz_url_config(patient, brick_store = BRICK_STORE)
  patient.length.must_equal 1
  patient[0].name.must_equal 'mortar'
  patient[0].version.must_equal '0.0.1'
  patient[0].location.method.must_equal 'download'
  patient[0].location.format.must_equal 'tar.gz'
  patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar/archive/master.tar.gz'
  File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
  patient[0].destination.must_equal File.join(brick_store, 'mortar-0.0.1')
  patient[0].exists?.must_equal false
  # @todo
  # patient[0].create!
  # patient[0].exists?.must_equal true
end

describe Mortar do

  before do
    FileUtils.rm_rf BRICK_STORE
  end

  after do
    FileUtils.rm_rf BRICK_STORE
  end
  it 'detects whether or not the brick store exists' do
    patient = Mortar::Config.new(BRICK_STORE)
    patient.store.must_equal BRICK_STORE
    patient.store_exists?.must_equal false
    patient.store = File.expand_path '..', __FILE__
    patient.store.must_equal File.expand_path('..', __FILE__)
    patient.store_exists?.must_equal true
  end
  it 'can create and destroy the brick store' do
    patient = Mortar::Config.new(BRICK_STORE)
    patient.store.must_equal BRICK_STORE
    patient.store_exists?.must_equal false
    patient.create_store!
    patient.store_exists?.must_equal true
    patient.destroy_store!
    patient.store_exists?.must_equal false
  end
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
        test_git_https_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
      end

      it 'from file' do
        test_git_https_config(
          Mortar::Config.new(BRICK_STORE).parse_file(
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
        test_git_https_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
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
        test_git_ssh_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
      end

      it 'from file' do
        test_git_ssh_config(
          Mortar::Config.new(BRICK_STORE).parse_file(
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
        test_git_ssh_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
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
        patient = Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
        patient.length.must_equal 1
        patient[0].name.must_equal 'mortar'
        patient[0].version.must_equal '0.0.1'
        patient[0].location.method.must_equal 'svn'
        patient[0].location.format.must_equal 'plain'
        patient[0].location.url.must_equal 'https://github.com/dmorrill10/mortar'
        File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
        patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
        patient[0].exists?.must_equal false
        patient[0].create!
        patient[0].exists?.must_equal true
        patient[0].destroy!
        patient[0].exists?.must_equal false
      end

      it 'from file' do
        patient = Mortar::Config.new(BRICK_STORE).parse_file(
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
        File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
        patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
        patient[0].exists?.must_equal false
        patient[0].create!
        patient[0].exists?.must_equal true
        patient[0].destroy!
        patient[0].exists?.must_equal false
      end

      it 'where the method is not explicitly specified' do
        test_brickfile_config = <<-END
-
  name: mortar
  version: 0.0.1
  location: svn://github.com/dmorrill10/mortar
END
        patient = Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
        patient.length.must_equal 1
        patient[0].name.must_equal 'mortar'
        patient[0].version.must_equal '0.0.1'
        patient[0].location.method.must_equal 'svn'
        patient[0].location.format.must_equal 'plain'
        patient[0].location.url.must_equal 'svn://github.com/dmorrill10/mortar'
        File.basename(patient[0].destination).must_equal 'mortar-0.0.1'
        patient[0].destination.must_equal File.join(BRICK_STORE, 'mortar-0.0.1')
        patient[0].exists?.must_equal false
        patient[0].create!
        patient[0].exists?.must_equal true
        patient[0].destroy!
        patient[0].exists?.must_equal false
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
        test_zip_url_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
      end

      it 'from file' do
        test_zip_url_config(
          Mortar::Config.new(BRICK_STORE).parse_file(
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
        test_tar_gz_url_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config)
      end
      it 'from string with store key' do
        custom_store = '../custom_store'
        test_brickfile_config = <<-END
store: #{custom_store}
bricks:
  -
    name: mortar
    version: 0.0.1
    location: https://github.com/dmorrill10/mortar/archive/master.tar.gz
END
        test_tar_gz_url_config Mortar::Config.new(BRICK_STORE).parse(test_brickfile_config), custom_store
      end
    end

    # @todo Copy the above tests, but for hg and local project configurations (see support/test_files for example configurations)

    # @todo A little more has to be done for local project, since the path to the local project might have to be relative to the brickfile, so I can do that one
  end
end
