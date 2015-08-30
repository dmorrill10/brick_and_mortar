require_relative 'support/spec_helper'

require_relative '../lib/brick_and_mortar/git'

describe BrickAndMortar::Git do
  describe 'given git ssh brick configuration' do
    git_ssh_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('git', 'git@github.com:dmorrill10/brick_and_mortar.git')
    )

    it 'downloads the brick with git ssh' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          BrickAndMortar::Git.clone_repo(git_ssh_brick_configruation.location.url, git_ssh_brick_configruation.name)
          File.directory?(File.join(dir, git_ssh_brick_configruation.name)).must_equal true
        end
      end
    end
  end
  describe 'given git https brick configuration' do
    git_https_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new('git', 'https://github.com/dmorrill10/brick_and_mortar.git')
    )

    it 'downloads the brick with git https' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |d|
          BrickAndMortar::Git.clone_repo(git_https_brick_configruation.location.url, git_https_brick_configruation.name)
          File.directory?(File.join(dir, git_https_brick_configruation.name)).must_equal true
        end
      end
    end
  end
end
