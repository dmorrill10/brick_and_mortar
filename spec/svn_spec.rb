require_relative 'support/spec_helper'

require_relative '../lib/mortar/svn'

describe Mortar::Svn do
  describe 'given svn brick configuration' do
    svn_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('svn', 'https://github.com/dmorrill10/mortar')
    )

    it 'downloads the brick with svn' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          Mortar::Svn.checkout_repo(svn_brick_configruation.location.url, svn_brick_configruation.name)
          File.directory?(File.join(dir, svn_brick_configruation.name)).must_equal true
        end
      end
    end
  end
  describe 'given svn brick configuration' do
    git_https_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('svn', 'https://github.com/dmorrill10/mortar')
    )

    it 'downloads the brick with svn' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          Mortar::Svn.checkout_repo(git_https_brick_configruation.location.url, git_https_brick_configruation.name)
          File.directory?(File.join(dir, git_https_brick_configruation.name)).must_equal true
        end
      end
    end
  end
end
