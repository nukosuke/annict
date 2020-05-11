# frozen_string_literal: true

class CreateWorkRecordService
  def initialize(user:, work:)
    @user = user
    @work = work
  end

  def call(work_record_attributes, share_record_to_twitter: false)
    work_record = user.work_records.new(work_record_attributes)
    work_record.work = work
    work_record.detect_locale!(:body)

    ActiveRecord::Base.transaction do
      work_record.activity = user.create_or_last_activity!(work_record, :create_work_record)
      work_record.record = user.records.create!(work: work)

      work_record.save!

      user.update_share_record_setting(share_record_to_twitter)
      work.update_record_body_count!(nil, work_record, field: :work_records_with_body_count)

      if user.share_record_to_twitter?
        user.share_work_record_to_twitter(work_record)
      end
    end
  end

  private

  attr_reader :user, :work
end
