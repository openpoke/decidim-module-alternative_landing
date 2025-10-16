# frozen_string_literal: true

module Decidim
  module AlternativeLanding
    module ContentBlocks
      class SidebarRightStackCell < BaseCell
        def translated_title(section)
          translated_attribute(model.settings.send("title_#{section}"))
        end

        def translated_body
          translated_attribute(model.settings.body)
        end

        def translated_link_text(section)
          translated_attribute(model.settings.send("link_text_#{section}"))
        end

        def translated_url(section)
          translated_attribute(model.settings.send("link_url_#{section}"))
        end

        def background_image
          model.images_container.attached_uploader(:background_image).path(variant: :big)
        end

        def meetings
          meeting_ids = Array(model.settings[:meeting_ids]).map(&:to_i).compact_blank
          scope = Decidim::Meetings::Meeting.upcoming.order(start_time: :asc)

          case model.settings.meetings_component_id
          when "meeting-picker"
            return Decidim::Meetings::Meeting.none if meeting_ids.empty?

            Decidim::Meetings::Meeting.where(id: meeting_ids)
          when "all"
            scope
          else
            scope.where(component: component(:meetings_component))
          end
        end

        def posts
          scope = posts_component = component(:posts_component)
          scope = scope ? Blogs::Post.where(component: posts_component) : Blogs::Post.all

          scope = case model.settings.filter_posts
                  when "organization" then scope.where(decidim_author_type: "Decidim::Organization")
                  when "users" then scope.where(decidim_author_type: "Decidim::UserBaseEntity")
                  else scope
                  end

          scope.order(created_at: :desc)
        end
      end
    end
  end
end
