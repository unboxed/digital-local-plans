  class EditTimetableEventForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_accessor :event_date, :actual_date, :entry_date

    def save(event)
      return false unless valid?

      event.update!(
        event_date:,
        actual_date:,
        entry_date:,
      )
    end
  end
