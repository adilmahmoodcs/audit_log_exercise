class ActivityLog < ActiveRecord::Base
  belongs_to :model, polymorphic: true
end
