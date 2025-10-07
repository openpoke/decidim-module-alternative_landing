# frozen_string_literal: true

module Decidim
  module AlternativeLanding
    module ContentBlocks
      class MeetingsPickerCell < BaseCell
        def show
          render
        end

        alias meetings_component model

        def form
          options[:form]
        end

        def field
          options[:field]
        end

        def form_name
          "#{form.object_name}[#{field}]"
        end

        def selected_ids
          ids_string = form.object[:meeting_ids] || ""
          ids_string.split(",").map(&:strip).compact_blank.map(&:to_i)
        end

        def meetings
          return Meetings::Meeting.none unless meetings_component

          Meetings::Meeting
            .upcoming
            .where(component: meetings_component)
            .order(start_time: :asc)
        end

        def decorated_meetings
          meetings.map do |meeting|
            Decidim::Meetings::MeetingPresenter.new(meeting)
          end
        end
      end
    end
  end
end
