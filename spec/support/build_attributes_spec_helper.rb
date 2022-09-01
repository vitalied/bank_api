module BuildAttributesSpecHelper
  def build_attributes(obj, *attrs)
    obj&.attributes&.symbolize_keys&.slice(*attrs)
  end
end

RSpec.configure do |config|
  config.include BuildAttributesSpecHelper
end
