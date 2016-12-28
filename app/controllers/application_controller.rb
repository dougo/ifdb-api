class ApplicationController < ActionController::API
  ActionController::Renderers.add :hal do |model, options|
    self.content_type ||= Mime[:hal]
    model.to_hal
  end
end
