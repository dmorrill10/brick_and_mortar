MockBrickConfiguration = Struct.new(:name, :version, :location)
MockBrickLocation = Struct.new(:method, :path) do
  alias_method :url, :path
end
