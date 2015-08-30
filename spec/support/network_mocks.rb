module Mortar
  def self.create_directory!(url, name = nil)
    unless name
      name = File.basename(url, File.extname(url))
    end
    FileUtils.mkpath name
  end
  module Download
    def self.get_and_unpack_zip(url, name = nil, options = {})
      Mortar::create_directory! url, name
    end
    def self.get_and_unpack_tar_gz(url, name = nil, options = {})
      Mortar::create_directory! url, name
    end
  end
  module Git
    def self.clone_repo(url, name = nil, options = {})
      Mortar::create_directory! url, name
    end
  end
  module Svn
    def self.checkout_repo(url, name = nil, options = {})
      unless name
        split_url = url.split '/'
        name = if split_url.last == 'trunk'
          split_url.last
        else
          split_url[-2]
        end
      end
      FileUtils.mkpath name
    end
  end
end
