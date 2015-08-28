require 'open-uri'
require 'zip'

module Mortar
  module Download
    def self.get(url)
      puts "  Url: #{url}"
      open(url).read
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
    def self.get_and_unpack_zip(url, name = nil, options = {})
      unless name
        name = File.basename(url, File.extname(url))
      end
      unzipped_dir_name = unzip(open(url))
      FileUtils.mv unzipped_dir_name, name
    end
  end
end
