require 'open-uri'
require 'zip'
require 'zlib'
require 'rubygems/package'

module Mortar
  module Download
    def self.name_from_url(url)
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
    def self.deflate_tar_gz(path)
      destination_to_return = nil
      root_created = false
      destination = '.'
      Gem::Package::TarReader.new(Zlib::GzipReader.open(path)) do |tar|
        dest = nil
        tar.each do |entry|
          if entry.full_name == path
            dest = File.join destination, entry.read.strip
            next
          end
          dest ||= File.join destination, entry.full_name
          if entry.directory? || (entry.header.typeflag == '' && entry.full_name.end_with?('/'))
            File.delete dest if File.file? dest
            FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
            unless root_created
              destination_to_return = dest
            end
            root_created = true
          else
            unless root_created
              destination = name_from_url path
              FileUtils.mkdir_p destination
              destination_to_return = destination
              root_created = true
            end
            if entry.file? || (entry.header.typeflag == '' && !entry.full_name.end_with?('/'))
              FileUtils.rm_rf dest if File.directory? dest
              File.open dest, "wb" do |f|
                f.print entry.read
              end
              FileUtils.chmod entry.header.mode, dest, :verbose => false
            elsif entry.header.typeflag == '2' #Symlink!
              File.symlink entry.header.linkname, dest
            else
              puts "WARNING: Unknown tar entry: #{entry.full_name} type: #{entry.header.typeflag}."
            end
          end
          dest = nil
        end
      end
      destination_to_return
    end
    def self.get_and_unpack_zip(url, name = nil, options = {})
      unless name
        name = name_from_url url
      end
      unzipped_dir_name = unzip(open(url))
      FileUtils.mv unzipped_dir_name, name
    end
    def self.get_and_unpack_tar_gz(url, name = nil, options = {})
      unless name
        name = name_from_url url
      end
      uncompressed_dir_name = deflate_tar_gz(open(url))
      FileUtils.mv uncompressed_dir_name, name
    end
  end
end
