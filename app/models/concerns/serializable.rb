module Serializable
  extend ActiveSupport::Concern

  def to_hal
    yaks = Yaks.new do
      map_to_primitive Date, Time, DateTime, ActiveSupport::TimeWithZone, &:iso8601
    end
    yaks.call(self)
  end
end
