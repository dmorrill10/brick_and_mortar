require_relative 'git'
require_relative 'svn'
require_relative 'download'

require 'contextual_exceptions'

module Mortar
  module Brick
    class Location
      using ContextualExceptions::ClassRefinement
      exceptions :no_path_or_url_provided, :unrecognized_format
      attr_reader :method, :path, :format

      FORMATS = {:plain => 'plain', :zip => 'zip', :tar_gz => 'tar.gz'}

      def self.url_to_format(url)
        if url.match(/\.zip$/)
          FORMATS[:zip]
        elsif url.match(/\.tar.gz$/)
          FORMATS[:tar_gz]
        else
          FORMATS[:plain]
        end
      end

      alias_method :url, :path

      def initialize(data)
        if data['path'] && !data['path'].empty? && data['url'] && data['url'].empty?
          fail "Path was specified as \"#{data['path']}\", but url was specified as \"#{data['url']}\". Only one can be defined at a time."
        end

        @format = FORMATS[:plain]

        if data.respond_to?(:match)
          if data.match(/^\s*svn:/)
            @method = 'svn'
          elsif data.match(/^\s*git:/) || data.match(/\.git\s*$/)
            @method = 'git'
          elsif data.match(/^\s*https?:/)
            @method = 'download'
          end
          @path = data
          @format = self.class().url_to_format(data)
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

        fail NoPathOrUrlProvided.new('Must have a path or URL') unless @path
        unless FORMATS.values.include?(@format)
          fail UnrecognizedFormat.new("Unrecognized format: #{@format}. Recognized formats: #{FORMATS}.")
        end
      end
    end
    class Config
      using ContextualExceptions::ClassRefinement
      exceptions :unrecognized_retrieval_method, :unrecognized_format

      attr_reader :name, :version, :location, :destination

      def initialize(data, brick_store, verbose = true)
        @name = data['name']
        @version = data['version']
        @location = Location.new(data['location'])
        @destination = File.join(brick_store, name_with_version)

        @creation_closure = if exists?
          if verbose
            -> { puts "Using #{name_with_version} in #{@destination}" }
          else
            -> {}
          end
        else
          case @location.method
          when 'git'
            -> do
              if verbose
                puts "Installing #{name_with_version} to #{@destination} from #{@location.path} with git"
              end
              Git.clone_repo(@location.path, @destination)
            end
          when 'svn'
            -> do
              if verbose
                puts "Installing #{@name_with_version} to #{@destination} from #{@location.path} with svn"
              end
              Svn.checkout_repo(@location.path, @destination)
            end
          when 'download'
            -> do
              if verbose
                puts "Installing #{@name_with_version} to #{@destination} from #{@location.path}"
              end
              if @location.format == Location::FORMATS[:zip]
                Download.get_and_unpack_zip(@location.path, @destination)
              elsif
                if @location.format == Location::FORMATS[:tar_gz]
                  Download.get_and_unpack_tar_gz(@location.path, @destination)
                end
              else
                ap @location.format
                raise UnrecognizedFormat.new(@location.format)
              end
            end
          else
            -> { raise UnrecognizedRetrievalMethod.new(@location.method) }
          end
        end
      end

      def name_with_version
        "#{@name}-#{@version}"
      end

      def exists?
        File.exist? @destination
      end

      alias_method :exist?, :exists?

      def create!
        @creation_closure.call
      end

      def laid?(project_vendor_dir)
        File.exist? File.join(project_vendor_dir, name)
      end

      def lay!(project_vendor_dir)
        create!
        File.symlink @destination, File.join(project_vendor_dir, name)
      end

      def destroy!
        FileUtils.rm_rf @destination, {:secure => true}
      end
    end
  end
end
