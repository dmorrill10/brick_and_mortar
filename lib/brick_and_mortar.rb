require 'brick_and_mortar/version'
require 'brick_and_mortar/brick'
require 'brick_and_mortar/download'
require 'brick_and_mortar/project'
require 'brick_and_mortar/config'
require 'brick_and_mortar/git'
require 'brick_and_mortar/svn'

module BrickAndMortar
end

# @todo This should be helpful
# require 'pathname'
# require 'yaml'
# require 'fileutils'
# require 'rake'
#
#    def self.ensure_directory_present(dir)
#      FileUtils.mkpath dir unless File.exists? dir
#      raise "Results directory, \"#{dir}\" is not a directory!" unless File.directory?(dir)
#    end
#
#  def self.resolve_path(path, root = __FILE__)
#    path = Pathname.new(path)
#    if path.exist?
#      path.realpath
#    else
#      File.expand_path(path, root)
#    end
#  end
#
#    def self.from_yaml(yaml_file, num_reps = 1, quiet = false)
#      yaml_directory = File.expand_path('../', yaml_file)
#      config_data = YAML.load_file(yaml_file)
#      interpolation_hash = { pwd: yaml_directory, home: Dir.home, :~ => Dir.home }
#      dealer_directory = ::PokerTournament.resolve_path(
#        config_data['dealer_directory'] % interpolation_hash,
#        yaml_directory
#      ).to_s
#      interpolation_hash[:dealer_directory] = dealer_directory
#
#      new(
#        ::PokerTournament.resolve_path(
#          config_data['match_directory'] % interpolation_hash, yaml_directory
#        ).to_s,
#        ::PokerTournament.resolve_path(
#          config_data['game_def'] % interpolation_hash,
#          yaml_directory
#        ).to_s,
#        config_data['participants'].map do |player|
#          Participant.new(
#            player['name'],
#            (->() do
#              argument = player['strategy'] % interpolation_hash
#              strategy_argument = ::PokerTournament.resolve_path(
#                argument,
#                yaml_directory
#              ).to_s
#              unless File.exist? strategy_argument
#                strategy_argument = argument
#              end
#              strategy_argument
#            end).call(),
#            ::PokerTournament.resolve_path(
#              player['dealer_player_object'] % interpolation_hash,
#              yaml_directory
#            ).to_s
#          )
#        end,
#        config_data['num_hands'].to_i,
#        config_data['num_players'].to_i,
#        dealer_directory,
#        num_reps,
#        config_data['random_seed'].to_i,
#        quiet
#      )
#    end
