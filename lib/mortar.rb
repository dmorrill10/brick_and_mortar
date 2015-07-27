require 'mortar/version'

require 'yaml'

module Mortar
  module Brick
    class Location
      attr_reader :method, :path

      alias_method :url, :path

      def initialize(data)
        @path = if data['path']
          data['path']
        elsif data['url']
          data['url']
        end
        @method = data['method'] if data['method']
        if data.respond_to?(:match) && data.match(/^\s*https?:/)
          @path = data['url']
          @method = 'download'
        elsif @path.nil?
          @path = data['path']
          @method = 'copy'
        end
        fail 'Must have a path or URL' unless @path
      end
    end
    class Config
      attr_reader :name, :version, :location

      def initialize(data)
        @name = data['name']
        @version = data['version']
        @location = Location.new(data['location'])
      end
    end
  end

  def self.parse(yaml)
    YAML.load(yaml).map do |data|
      Brick::Config.new(data)
    end
  end

  def self.parse_file(yaml_file)
    YAML.load_file(yaml_file).map do |data|
      Brick::Config.new(data)
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
