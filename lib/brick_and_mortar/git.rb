require 'git'

module BrickAndMortar
  module Git
    def self.clone_repo(url, name = nil, options = {})
      unless name
        name = File.basename(url, File.extname(url))
      end
      ::Git.clone(url, name, options)
    end
  end
end