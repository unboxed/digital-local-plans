# frozen_string_literal: true

class AddPlanToTimetables < ActiveRecord::Migration[8.1]
  class MigrationTimetable < ActiveRecord::Base
    self.table_name = "timetables"
  end

  class MigrationPlan < ActiveRecord::Base
    self.table_name = "plans"
  end

  def up
    add_reference :timetables, :plan, foreign_key: true, index: {unique: true}

    MigrationTimetable.where(plan_id: nil).find_each do |timetable|
      plan = MigrationPlan.create!(organisation_id: timetable.organisation_id, status: "draft")
      timetable.update_columns(plan_id: plan.id)
    end

    change_column_null :timetables, :plan_id, false
  end

  def down
    remove_reference :timetables, :plan, foreign_key: true, index: {unique: true}
  end
end
