# frozen_string_literal: true

module Decidim
  module AlternativeLanding
    module ContentBlocks
      class BaseCell < BaseCell
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
          "#{form.object_name}[#{method_name}]"
        end

        def method_name
          field.to_s.sub(/s$/, "_ids")
        end

        def selected_ids
          form.object.send(method_name)
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
