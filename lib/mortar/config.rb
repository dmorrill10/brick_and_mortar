require 'fileutils'
require 'yaml'

require 'mortar/brick'

module Mortar
  class Config
    attr_accessor :store

    def initialize(store_)
      @store = store_
    end

    def store_exists?
      Dir.exist? @store
    end

    def create_store!
      unless store_exists?
        FileUtils.mkpath @store
        fail "Could not create store at \"#{@store}\"" unless store_exists?
      end
    end

    def destroy_store!
      FileUtils.rm_rf @store
    end

    alias_method :store_exist?, :store_exists?

    def parse_data!(brick_data, store_ = @store)
      brick_data.map do |brick|
        Brick::Config.new(brick, store_)
      end
    end

    def bricks_and_store_from_data(data)
      store_ = @store
      begin
        brick_data = if data['store'] && !data['store'].empty?
          store_ = data['store']
          data['bricks']
        elsif data['bricks']
          data['bricks']
        else
          []
        end
      rescue TypeError
        brick_data = data
      end
      [brick_data, store_]
    end

    def parse!(yaml)
      brick_data, store_ = bricks_and_store_from_data YAML.load(yaml)
      parse_data! brick_data, store_
    end

    def parse_file!(yaml_file)
      brick_data, store_ = bricks_and_store_from_data YAML.load_file(yaml_file)
      parse_data! brick_data, store_
    end
  end
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
