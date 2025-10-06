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
          @meetings ||= Meetings::Meeting.upcoming.where(
            component: component || components
          )
        end

        def posts
          return Blogs::Post.none unless posts_component

          scope = Blogs::Post.where(component: posts_component)

          case model.settings.filter_posts
          when "organization"
            scope = scope.where(decidim_author_type: "Decidim::Organization")
          when "users"
            scope = scope.where(decidim_author_type: "Decidim::UserBaseEntity")
          end

          scope.order(created_at: :desc)
        end

        def meetings_component
          @meetings_component ||= Decidim::Component.find_by(id: model.settings.meetings_component_id)
        end

        def posts_component
          @posts_component ||= Decidim::Component.find_by(id: model.settings.posts_component_id)
        end
      end
    end
  end
end
