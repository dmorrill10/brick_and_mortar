require 'fileutils'
require 'brick_and_mortar/config'

module BrickAndMortar
  class Project
    attr_reader :project_root, :config, :bricks

    DEFAULT_BRICK_STORE = File.join(Dir.home, '.bricks')

    def initialize(brickfile, brick_store = DEFAULT_BRICK_STORE)
      @config = Config.new brick_store
      @config.create_store!
      @bricks = @config.parse_file! brickfile
      @project_root = File.dirname(brickfile)
    end

    def vendor
      File.join(@project_root, 'vendor')
    end

    def laid?
      @bricks.reduce(File.exist?(vendor)) do |has_been_laid, brick|
        break has_been_laid unless has_been_laid
        has_been_laid && brick.laid?(vendor)
      end
    end

    def lay!
      FileUtils.mkpath vendor
      @bricks.each do |b|
        b.lay! vendor
        sub_brickfile = File.join(b.destination, 'Brickfile')
        if File.file?(sub_brickfile)
          Dir.chdir(b.destination) do |dir|
            subproject = Project.new(sub_brickfile, @config.store)
            subproject.lay!
          end
        end
      end
    end
  end
end
