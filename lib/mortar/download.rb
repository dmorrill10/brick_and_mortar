require 'open-uri'
require 'zip'
require 'zlib'
require 'rubygems/package'

module Mortar
  module Download
    TAR_LONGLINK = '././@LongLink'

    def self.name_from_path(url)
      File.basename(url, File.extname(url))
    end
    def self.unzip(zip_file)
      root_dir_name = nil
      Zip::File.open(zip_file) do |z|
        z.each do |entry|
          next unless entry.file?
          fpath = entry.to_s
          unless root_dir_name
            root_dir_name = File.dirname fpath
          end
          unless File.exist?(entry.name)
            FileUtils::mkdir_p(File.dirname(entry.name))
            # puts "Extracting #{entry.name} to #{fpath}"
            entry.extract(entry.name)
          end
        end
      end
      root_dir_name
    end
    # Thanks to TomCZ
    # http://stackoverflow.com/questions/856891/unzip-zip-tar-tag-gz-files-with-ruby
    # for this
    def self.deflate_tar_gz(tar_gz_archive, destination = Dir.pwd)
      first_directory = nil
      Gem::Package::TarReader.new( Zlib::GzipReader.open tar_gz_archive ) do |tar|
        dest = nil
        tar.each do |entry|
          if entry.full_name == TAR_LONGLINK
            dest = File.join destination, entry.read.strip
            next
          end
          dest ||= File.join destination, entry.full_name
          if entry.directory?
            FileUtils.rm_rf dest unless File.directory? dest
            FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
            first_directory = dest unless first_directory
          elsif entry.file?
            FileUtils.rm_rf dest unless File.file? dest
            File.open dest, "wb" do |f|
              f.print entry.read
            end
            FileUtils.chmod entry.header.mode, dest, :verbose => false
            unless first_directory
              puts "WARNING: File \"#{dest}\" created before a root directory"
            end
          elsif entry.header.typeflag == '2' #Symlink!
            File.symlink entry.header.linkname, dest
            unless first_directory
              puts "WARNING: Symlink \"#{dest}\" to \"#{entry.header.linkname}\" created before a root directory"
            end
          end
          dest = nil
        end
      end
      first_directory
    end
    def self.get_and_unpack_zip(url, name = nil, options = {})
      unless name
        name = name_from_path url
      end
      unzipped_dir_name = unzip(open(url))
      FileUtils.mv unzipped_dir_name, name
    end
    def self.get_and_unpack_tar_gz(url, name = nil, options = {})
      unless name
        name = name_from_path url
      end
      uncompressed_dir_name = deflate_tar_gz(open(url))
      FileUtils.mv uncompressed_dir_name, name
    end
  end
end
