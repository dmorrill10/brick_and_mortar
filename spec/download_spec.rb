require_relative 'support/spec_helper'

require_relative '../lib/brick_and_mortar/download'

describe BrickAndMortar::Download do
  describe 'given zip url brick configuration' do
    zip_url_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('download', 'https://github.com/dmorrill10/brick_and_mortar/archive/master.zip')
    )

    it 'downloads the brick' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          BrickAndMortar::Download.get_and_unpack_zip(zip_url_brick_configruation.location.url, zip_url_brick_configruation.destination)
          File.directory?(File.join(dir, zip_url_brick_configruation.destination)).must_equal true
        end
      end
    end
  end
  describe 'given tar.gz url brick configuration' do
    tar_gz_url_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('download', 'https://github.com/dmorrill10/brick_and_mortar/archive/master.tar.gz')
    )

    it 'downloads the brick' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          BrickAndMortar::Download.get_and_unpack_tar_gz(tar_gz_url_brick_configruation.location.url, tar_gz_url_brick_configruation.destination)
          File.directory?(File.join(dir, tar_gz_url_brick_configruation.destination)).must_equal true
        end
      end
    end
  end

  describe 'given tar.bz2 url brick configuration' do
    tar_bz2_url_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('download', 'http://www.computerpokercompetition.org/downloads/code/competition_server/project_acpc_server_v1.0.41.tar.bz2')
    )

    it 'downloads the brick' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          BrickAndMortar::Download.get_and_unpack_tar_bz2(
            tar_bz2_url_brick_configruation.location.url,
            tar_bz2_url_brick_configruation.destination
          )
          File.directory?(File.join(dir, tar_bz2_url_brick_configruation.destination)).must_equal true
        end
      end
    end
  end
end
