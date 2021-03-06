require_relative 'git'
require_relative 'svn'
require_relative 'download'

module BrickAndMortar
  module Brick
    class Location
      class NoPathOrUrlProvided < RuntimeError
      end
      class UnrecognizedFormat < RuntimeError
      end
      attr_reader :method, :path, :format

      FORMATS = {
        :plain => 'plain',
        :zip => 'zip',
        :tar_gz => 'tar.gz',
        :tar_bz2 => 'tar.bz2'
      }

      def self.url_to_format(url)
        if url.match(/\.#{FORMATS[:zip]}$/)
          FORMATS[:zip]
        elsif url.match(/\.#{FORMATS[:tar_gz]}$/)
          FORMATS[:tar_gz]
        elsif url.match(/\.#{FORMATS[:tar_bz2]}$/)
          FORMATS[:tar_bz2]
        else
          FORMATS[:plain]
        end
      end

      alias_method :url, :path

      def initialize(data)
        @format = FORMATS[:plain]
        if data.respond_to?(:keys)
          if data['path'] && !data['path'].empty? && data['url'] && data['url'].empty?
            fail "Path was specified as \"#{data['path']}\", but url was specified as \"#{data['url']}\". Only one can be defined at a time."
          end
          @path = if data['path']
            @method = 'copy'
            @format = self.class().url_to_format(data['path'])
            data['path']
          elsif data['url']
            @format = self.class().url_to_format(data['url'])
            data['url']
          else
            @path
          end
          @method = data['method'] if data['method']
          @format = data['format'] if data['format']
        else
          if data.match(/^\s*svn:/)
            @method = 'svn'
          elsif data.match(/^\s*git:/) || data.match(/\.git\s*$/)
            @method = 'git'
          elsif data.match(/^\s*https?:/)
            @method = 'download'
          else
            @method = 'copy'
          end
          @path = data
          @format = self.class().url_to_format(data)
        end

        fail NoPathOrUrlProvided.new('Must have a path or URL') unless @path
        unless FORMATS.values.include?(@format)
          fail UnrecognizedFormat.new("Unrecognized format: #{@format}. Recognized formats: #{FORMATS}.")
        end
      end
    end
    class Config
      class UnrecognizedRetrievalMethod < RuntimeError
      end
      class UnrecognizedFormat < RuntimeError
      end

      attr_reader :name, :version, :location, :destination

      def initialize(data, brick_store, verbose = true)
        @name = data['name']
        @version = data['version']
        @location = Location.new(data['location'])
        @destination = File.join(brick_store, name_with_version)
        @verbose = verbose
      end

      def name_with_version
        "#{@name}-#{@version}"
      end

      def exists?
        File.exist? @destination
      end

      alias_method :exist?, :exists?

      def create!
        if exists?
          if @verbose
            puts "Using #{name_with_version} in #{@destination}"
          end
        else
          case @location.method
          when 'git'
            if @verbose
              puts "Installing #{name_with_version} to #{@destination} from #{@location.path} with git"
            end
            Git.clone_repo(@location.path, @destination)
          when 'svn'
            if @verbose
              puts "Installing #{@name_with_version} to #{@destination} from #{@location.path} with svn"
            end
            Svn.checkout_repo(@location.path, @destination)
          when 'download'
            if @verbose
              puts "Installing #{@name_with_version} to #{@destination} from #{@location.path}"
            end
            if @location.format == Location::FORMATS[:zip]
              Download.get_and_unpack_zip(@location.path, @destination)
            elsif @location.format == Location::FORMATS[:tar_gz]
              Download.get_and_unpack_tar_gz(@location.path, @destination)
            elsif @location.format == Location::FORMATS[:tar_bz2]
              Download.get_and_unpack_tar_bz2(@location.path, @destination)
            else
              raise UnrecognizedFormat.new(@location.format)
            end
          when 'copy'
            if @verbose
              puts "Copying #{@name_with_version} to #{@destination} from #{@location.path}"
            end
            dir = File.dirname(@destination)
            FileUtils.mkdir_p(dir) unless File.directory?(dir)
            FileUtils.cp_r @location.path, @destination
          else
            raise UnrecognizedRetrievalMethod.new(@location.method)
          end
        end
      end

      def laid?(project_vendor_dir)
        File.exist? File.join(project_vendor_dir, name)
      end

      def lay!(project_vendor_dir)
        create!
        unless laid?(project_vendor_dir)
          File.symlink @destination, File.join(project_vendor_dir, name)
        end
      end

      def destroy!
        FileUtils.rm_rf @destination, {:secure => true}
      end
    end
  end
end
