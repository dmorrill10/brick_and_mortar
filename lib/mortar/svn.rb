module Mortar
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

      # @todo This doesn't set the working directory properly for svn, but it's needed to handle the case where the user needs to interact with svn (for password, for instance)
      # IO.popen "svn co #{url} #{name}"

      system "svn co #{url} #{name}"
    end
  end
end