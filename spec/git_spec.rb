require_relative 'support/spec_helper'
require 'git'

require_relative '../lib/brick_and_mortar/git'

describe BrickAndMortar::Git do
  describe 'given git brick configuration' do
    it 'installs the brick with git' do
      Dir.mktmpdir do |dir|
        mock_git_repo = "#{dir}/git_remotes/mock_git_repo.git"
        FileUtils.mkdir_p mock_git_repo
        Git.init mock_git_repo, bare: true
        git_brick_configruation = MockBrickConfiguration.new(
          'mock_brick',
          '0.0.1',
          MockBrickLocation.new('git', mock_git_repo)
        )
        Dir.chdir dir do |_d|
          BrickAndMortar::Git.clone_repo(
            git_brick_configruation.location.url,
            git_brick_configruation.name
          )
          File.directory?(
            File.join(dir, git_brick_configruation.name)
          ).must_equal true
        end
      end
    end
  end
  describe 'given git https brick configuration' do
    git_https_brick_configruation = MockBrickConfiguration.new(
      'mock_brick',
      '0.0.1',
      MockBrickLocation.new(
        'git',
        'https://github.com/dmorrill10/brick_and_mortar.git'
      )
    )

    it 'downloads the brick with git https' do
      Dir.mktmpdir do |dir|
        Dir.chdir dir do |_d|
          BrickAndMortar::Git.clone_repo(
            git_https_brick_configruation.location.url,
            git_https_brick_configruation.name
          )
          File.directory?(
            File.join(dir, git_https_brick_configruation.name)
          ).must_equal true
        end
      end
    end
  end
end
