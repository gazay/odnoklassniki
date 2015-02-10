require 'net/http'
require 'net/http/post/multipart'
require 'http_uploader'

require_relative '../odnoklassniki'

module Social
  module Content
    class Odnoklassniki
      class Photoalbum

        GET_ALBUMS_METHOD = 'photos.getAlbums'.freeze
        CREATE_ALBUM_METHOD = 'photos.createAlbum'.freeze
        GET_ALBUM_UPLOAD_URL_METHOD = 'photosV2.getUploadUrl'.freeze
        COMMIT_PHOTO_METHOD = 'photosV2.commit'.freeze

        ALBUM_NAME = 'amplifr'.freeze
        ALBUM_CREATION_OPTIONS = {
          title: ALBUM_NAME,
          description: 'Album for uploads from amplifr app'.freeze,
          type: 'public'.freeze
        }.freeze

        def initialize(account)
          @account = account
          @api = API::Odnoklassniki.new(account)
        end

        def upload(photo)
          upload_photoalbum_photo(photo)
        end

        private

        Error = Class.new(StandardError)
        FindingError = Class.new(Error)
        CreationError = Class.new(Error)
        UploadingError = Class.new(Error)

        def upload_photoalbum_photo(photo)
          upload_response = ::HttpUploader.new(photoalbum_upload_url)
            .upload(photo.to_io,
                    photo.basename,
                    query_param: :pic1, content_type: photo.content_type)

          unless Net::HTTPSuccess === upload_response
            raise UploadingError, "Failed to upload file. Reason: #{upload_response.body}"
          end

          photo_id, photo_attributes = JSON.parse(upload_response.body)
            .try(:[], 'photos').try(:flatten)

          if photo_id.blank? || photo_attributes.blank?
            raise UploadingError, "Broken upload response. Response: #{upload_response.body}"
          end

          if @account.personal?
            commit_uploaded_photo(photo_id, photo_attributes['token'])
          else
            photo_attributes['token']
          end
        end

        def photoalbum
          @photoalbum ||= begin
            params = {method: GET_ALBUMS_METHOD}
            params.merge!(gid: @account.group_id) if @account.group?

            @api.api(:get, params).try(:[], 'albums').to_a
              .find { |album| album['title'] == ALBUM_NAME }
          rescue API::Error
            raise FindingError
          end
        end

        def create_photoalbum
          return photoalbum['aid'] if photoalbum.present?

          params = {method: CREATE_ALBUM_METHOD}.merge!(ALBUM_CREATION_OPTIONS)
          params.merge!(gid: @account.group_id) if @account.group?

          @api.api(:get, params)
        rescue API::Error
          raise CreationError
        end

        def photoalbum_upload_url
          params = {method: GET_ALBUM_UPLOAD_URL_METHOD}

          if @account.group?
            params.merge!(gid: @account.group_id)
          else
            params.merge!(aid: create_photoalbum)
          end

          @api.api(:get, params) { |json| URI.parse json['upload_url'] }
        end

        def commit_uploaded_photo(photo_id, photo_token)
          params = {method: COMMIT_PHOTO_METHOD, photo_id: photo_id, token: photo_token}
          @api.api(:get, params) do |commit_response|
            commit_response['photos'][0]['assigned_photo_id']
          end
        end

      end # class Photoalbum
    end # class Odnoklassniki
  end # module Content
end # module Social

