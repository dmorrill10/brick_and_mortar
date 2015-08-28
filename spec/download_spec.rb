require_relative 'support/spec_helper'

require_relative '../lib/mortar/download'

describe Mortar::Download do
  describe 'given zip url brick configuration' do
    zip_url_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('download', 'https://github.com/dmorrill10/mortar/archive/master.zip')
    )

    it 'downloads the brick' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          Mortar::Download.get_and_unpack_zip(zip_url_brick_configruation.location.url, zip_url_brick_configruation.destination)
          File.directory?(File.join(dir, zip_url_brick_configruation.destination)).must_equal true
        end
      end
    end
  end
  # describe 'given tar.gz url brick configuration' do
  #   tar_gz_url_brick_configruation = MockBrickConfiguration.new(
  #     'mock_brick',
  #     '0.0.1',
  #     MockBrickLocation.new('download', 'https://github.com/dmorrill10/mortar/archive/master.tar.gz')
  #   )

  #   it 'downloads the brick' do
  #     Dir.mktmpdir do |dir|
  #       Dir.chdir dir do |d|
  #         Mortar::Download.get_and_unpack_tar_gz(tar_gz_url_brick_configruation.location.url, tar_gz_url_brick_configruation.destination)
  #         File.directory?(File.join(dir, tar_gz_url_brick_configruation.destination)).must_equal true
  #       end
  #     end
  #   end
  # end
end
