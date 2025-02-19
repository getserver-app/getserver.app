class BaseService
  def initialize(**params)
    params.each { |key, val| self.instance_variable_set("@#{key}".to_sym, val) }
  end

  def execute
    raise "Action::BaseAction.execute called, this method needs to be overwritten"
  end
end
