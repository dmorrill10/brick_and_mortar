require 'open-uri'
# Thanks to WinstonYW
# http://winstonyw.com/2013/10/02/openuris_open_tempfile_and_stringio/
# for this.
# Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0
require 'zip'
require 'zlib'
require 'rubygems/package'
require 'bzip2/ffi'

module BrickAndMortar
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
    def self.deflate_tar(tar_string, destination = Dir.pwd)
      first_directory = nil
      Gem::Package::TarReader.new(tar_string) do |tar|
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
            dir = File.dirname dest
            unless File.exist?(dir)
              FileUtils.mkpath dir
              first_directory = dir unless first_directory
            end
            File.open dest, "wb" do |f|
              f.print entry.read
            end
            FileUtils.chmod entry.header.mode, dest, :verbose => false
            unless first_directory
              puts "WARNING: File \"#{dest}\" created before a root directory"
            end
          elsif entry.header.typeflag == '2' #Symlink!
            dir = File.dirname dest
            unless File.exist?(dir)
              FileUtils.mkpath dir
              first_directory = dir unless first_directory
            end
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
    def self.deflate_tar_gz(tar_gz_archive, destination = Dir.pwd)
      deflate_tar(Zlib::GzipReader.open(tar_gz_archive), destination)
    end
    def self.deflate_tar_bz2(archive, destination = Dir.pwd)
      Bzip2::FFI::Reader.open(archive) do |reader|
        File.open("#{destination}.tar", 'w') do |tar|
          tar.write reader.read
        end
      end
      first_directory = File.open("#{destination}.tar", 'r') do |tar|
        deflate_tar(tar)
      end
      FileUtils.rm "#{destination}.tar"
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
    def self.get_and_unpack_tar_bz2(url, name = nil, options = {})
      unless name
        name = name_from_path url
      end
      uncompressed_dir_name = deflate_tar_bz2(open(url))
      FileUtils.mv uncompressed_dir_name, name
    end
  end
end
