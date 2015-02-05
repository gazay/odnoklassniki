module Odnoklassniki
  module REST
    class Mediatopic
      class Content
        VIDEO_LINK_PATTERN = /youtu\.?be|vimeo/.freeze
        AUDIO_LINK_PATTERN = /soundcloud|snd\.cc/.freeze
        EMBEDABLE_LINK_PATTERN = /#{VIDEO_LINK_PATTERN}|#{AUDIO_LINK_PATTERN}/.freeze
        TEXT_TYPE = 'text'.freeze
        LINK_TYPE = 'link'.freeze
        PHOTO_TYPE = 'photo'.freeze

        def initialize(params={})
          @params = _symbolize_kyes(params)
        end

        def message
          @message ||= {
            type: TEXT_TYPE,
            text: (text || '')
          }
        end

        def link
          @link ||= begin
            url = external_url
            url.blank? ? nil : {type: LINK_TYPE, url: external_url}
          end
        end

        def images
          @images ||= [resource_images].compact
        end

        private

        def image_id_key
          @image_id_key ||= account.personal_id.present? ? :photoId : :id
        end

        def resource_images
          return if resource.try(:images).blank?

          photos = resource.images.map do |photo|
            {image_id_key => photoalbum.upload(photo.image)}
          end

          {type: PHOTO_TYPE, list: photos}
        end

        def photoalbum
          @photoalbum ||= Photoalbum.new(account)
        end

        def has_single_embedable_link?
          has_single_link? && embedable_url?(urls[0])
        end

        def has_single_link?
          urls.count == 1
        end

        def text
          @text ||= params[:text]
        end

        def urls
          @urls ||= ::Twitter::Extractor.extract_urls(text)
        end

        def embedable_url?(url)
          url =~ EMBEDABLE_LINK_PATTERN
        end

        def shorten_links?
          account.project.count_click_rate? &&
            !has_single_embedable_link?
        end

        def external_url
          return unless resource.external_url?
          return resource.external_url unless shorten_links?

          @publication.links.where(original_url: resource.external_url)
            .first_or_create.short_or_generate
        end

        def _symbalize_keys(hash)
          symbolized = {}
          hash.each do |k, v|
            symbolized[k.to_sym] = v
          end
          hash
        end

      end
    end
  end
end
