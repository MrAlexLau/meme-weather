class Setting
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :theme, :search_term

  def initialize(defaults)
    defaults = (defaults || {}).deep_symbolize_keys
    self.theme = defaults[:theme] || 'cat'
    self.search_term = defaults[:search_term]
  end

  def persisted?
    false
  end
end