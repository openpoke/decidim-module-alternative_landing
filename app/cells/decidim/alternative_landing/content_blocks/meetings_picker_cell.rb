# frozen_string_literal: true

module Decidim
  module AlternativeLanding
    module ContentBlocks
      class MeetingsPickerCell < BaseCell
        def show
          render
        end

        alias component model

        def form
          options[:form]
        end

        def field
          options[:field]
        end

        def form_name
          "#{form.object_name}[settings][#{field}]"
        end

        def selected_ids
          form.object["settings"]&.meeting_ids&.map(&:to_i) || []
        end

        def meetings
          @meetings ||= Meetings::Meeting.upcoming.where(
            component: component || components
          )
        end

        def decorated_meetings
          meetings.each do |meeting|
            yield Decidim::Meetings::MeetingPresenter.new(meeting)
          end
        end
      end
    end
  end
end
