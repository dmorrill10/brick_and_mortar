class MockBrickConfiguration
  attr_accessor :name, :version, :location

  def initialize(name, version, location)
    @name = name
    @version = version
    @location = location
  end

  def destination
    "#{@name}-#{@version}"
  end
end
class MockBrickLocation
  attr_accessor :method, :path
  alias_method :url, :path

  def initialize(method, path, format = 'plain')
    @method = method
    @path = path
    @format = format
  end
end
