class ApplicationController < ActionController::API
  ActionController::Renderers.add :hal do |model, options|
    self.content_type ||= Mime[:hal]
    yaks = Yaks.new
    yaks.call(model)
  end
end
