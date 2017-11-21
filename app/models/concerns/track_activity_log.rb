module TrackActivityLog
  extend ActiveSupport::Concern

  included do
    after_create   :track_on_create
    after_update   :track_on_update
    before_destroy :track_on_destroy
    has_many :activity_logs, as: :model
  end

  private

  ACTION_ACTIVITIES = {
    create: "Created",
    update: "Updated",
    destroy: "Deleted"
  }.freeze

  def track_on_create
    create_activity(:create)
  end

  def track_on_update
    create_activity(:update) if saved_changes?
  end

  def track_on_destroy
    create_activity(:destroy)
  end

  def create_activity(action)
    options = prepare_options(action)
    ActivityLog.create!(options)
  end

  def prepare_options(action)
    {
      model_type: self.class.name,
      model_id: self.id,
      changes_text: action_changes_text(action)
    }
  end

  def action_changes_text(action)
    case action
    when :create
      attr_changes = self.saved_changes.map { |k, v| "#{k}: '#{v.second}'" }.to_sentence
      "#{performed_action(action)} {#{attr_changes}}"
    when :update
      attr_changes = self.saved_changes.map { |k, v| "#{k} from '#{v.first}' to '#{v.second}'" }.to_sentence
      "#{performed_action(action)} {#{attr_changes}}"
    when :destroy
      performed_action(action)
    end
  end

  def performed_action(action)
   "#{self.class.name} #{ACTION_ACTIVITIES[action]}"
  end

end
