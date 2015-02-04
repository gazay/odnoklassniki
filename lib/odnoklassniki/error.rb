# Taken and adopted from https://github.com/sferik/twitter gem
module Odnoklassniki
  # Custom error class for rescuing from all Odnoklassniki errors
  class Error < StandardError
    # @return [Integer]
    attr_reader :code

    # Raised when Odnoklassniki returns a 2xx HTTP status code
    ClientError = Class.new(self)

    # Raised when Odnoklassniki returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 401
    Unauthorized = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 403
    Forbidden = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 404
    NotFound = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 406
    NotAcceptable = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 422
    UnprocessableEntity = Class.new(ClientError)

    # Raised when Odnoklassniki returns the HTTP status code 429
    TooManyRequests = Class.new(ClientError)

    # Raised when Odnoklassniki returns a 5xx HTTP status code
    ServerError = Class.new(self)

    # Raised when Odnoklassniki returns the HTTP status code 500
    InternalServerError = Class.new(ServerError)

    # Raised when Odnoklassniki returns the HTTP status code 502
    BadGateway = Class.new(ServerError)

    # Raised when Odnoklassniki returns the HTTP status code 503
    ServiceUnavailable = Class.new(ServerError)

    # Raised when Odnoklassniki returns the HTTP status code 504
    GatewayTimeout = Class.new(ServerError)

    ERRORS = {
      200 => Odnoklassniki::Error::ClientError,
      400 => Odnoklassniki::Error::BadRequest,
      401 => Odnoklassniki::Error::Unauthorized,
      403 => Odnoklassniki::Error::Forbidden,
      404 => Odnoklassniki::Error::NotFound,
      406 => Odnoklassniki::Error::NotAcceptable,
      422 => Odnoklassniki::Error::UnprocessableEntity,
      429 => Odnoklassniki::Error::TooManyRequests,
      500 => Odnoklassniki::Error::InternalServerError,
      502 => Odnoklassniki::Error::BadGateway,
      503 => Odnoklassniki::Error::ServiceUnavailable,
      504 => Odnoklassniki::Error::GatewayTimeout,
    }

    module Code
      UNKNOWN                               = 1 # Unknown error
      SERVICE                               = 2 # Service temporary unavailable
      METHOD                                = 3 # Method does not exist.
      REQUEST                               = 4 # Failed to process request due to invalid request
      ACTION_BLOCKED                        = 7 # The requested action is temporarily blocked for current user
      FLOOD_BLOCKED                         = 8 # The execution of method is blocked due to flood
      IP_BLOCKED                            = 9 # The execution of method is blocked by IP address due to suspicious activity of current user or due to other restrictions applied to given method
      PERMISSION_DENIED                     = 10 # Permission denied. Possible reason - user not authorized application to perform operation
      LIMIT_REACHED                         = 11 # Method invocation limit reached
      CANCELLED	                            = 12 # Operation was cancelled by user
      NOT_MULTIPART                         = 21 # Not a multi-part request when uploading photo
      NOT_ACTIVATED                         = 22 # User must activate his profile to complete the action
      NOT_YET_INVOLVED                      = 23 # User not involved to the application - see notes (in russian)
      NOT_OWNER                             = 24 # User does not own specified object
      NOT_ACTIVE                            = 25 # Notification sending error. User not active in application.
      TOTAL_LIMIT_REACHED                   = 26 # Notification sending error. Notification limit reached. notes (in russian)
      PARAM                                 = 100 # Missing or invalid parameter
      PARAM_API_KEY                         = 101 # Parameter application_key not specified or invalid
      PARAM_SESSION_EXPIRED                 = 102 # Session key is expired
      PARAM_SESSION_KEY                     = 103 # Invalid session key
      PARAM_SIGNATURE                       = 104 # Invalid signature
      PARAM_RESIGNATURE                     = 105 # Invalid re-signature
      PARAM_ENTITY_ID                       = 106 # Invalid entity ID (discussions)
      PARAM_USER_ID                         = 110 # Invalid user ID
      PARAM_ALBUM_ID                        = 120 # Invalid album ID
      PARAM_PHOTO_ID                        = 121 # Invalid photo ID
      PARAM_WIDGET                          = 130 # Invalid Widget ID
      PARAM_MESSAGE_ID                      = 140 # Invalid message ID
      PARAM_COMMENT_ID                      = 141 # Invalid comment ID
      PARAM_HAPPENING_ID                    = 150 # Invalid happening ID
      PARAM_HAPPENING_PHOTO_ID              = 151 # Invalid happening photo ID
      PARAM_GROUP_ID                        = 160 # Invalid group ID
      PARAM_PERMISSION                      = 200 # Application can not perform operation. In most cases, caused by access to operation without user authorization
      PARAM_APPLICATION_DISABLED            = 210 # Application is disabled
      PARAM_DECISION                        = 211 # Invalid decision ID
      PARAM_BADGE_ID                        = 212 # Invalid badge ID
      PARAM_PRESENT_ID                      = 213 # Invalid present ID
      PARAM_RELATION_TYPE                   = 214 # Invalid relation type
      NOT_FOUND                             = 300 # Requested information is not found
      EDIT_PHOTO_FILE                       = 324 # Error processing multi-part request
      AUTH_LOGIN                            = 401 # Authentication failure. Invalid login/password or authentication token or user is deleted/blocked.
      AUTH_LOGIN_CAPTCHA                    = 402 # Authentication failure. Captcha entry is required for login.
      AUTH_LOGIN_WEB_HUMAN_CHECK            = 403 # Authentication failure.
      NOT_SESSION_METHOD                    = 451 # Session is prohibited for the method, but session key was specified
      SESSION_REQUIRED                      = 453 # Session key was not specified for the method, which requires session
      CENSOR_MATCH                          = 454 # Text rejected by censor
      FRIEND_RESTRICTION                    = 455 # Cannot perform operation because friend set restriction on it (put to "black list" or made his/her account private)
      GROUP_RESTRICTION                     = 456 # Cannot perform operation because group set restriction on it
      UNAUTHORIZED_RESTRICTION              = 457 # Unauthorized access
      PRIVACY_RESTRICTION                   = 458 # Same as FRIEND_RESTRICTION
      PHOTO_SIZE_LIMIT_EXCEEDED             = 500 # The size in bytes of image binary content exceeds the limits
      PHOTO_SIZE_TOO_SMALL                  = 501 # The image size in pixels are too small
      PHOTO_SIZE_TOO_BIG                    = 502 # The image size in pixels are too big
      PHOTO_INVALID_FORMAT                  = 503 # The image format cannot be recognized
      PHOTO_IMAGE_CORRUPTED                 = 504 # The image format is recognized, but the content is corrupted
      PHOTO_NO_IMAGE                        = 505 # No image is found in request
      PHOTO_PIN_TOO_MUCH                    = 508 # Too much photopin's on photo.
      IDS_BLOCKED                           = 511 # Photopin error from antispam system
      PHOTO_ALBUM_NOT_BELONGS_TO_USER       = 512 # Album not belongs to the user
      PHOTO_ALBUM_NOT_BELONGS_TO_GROUP      = 513 # Album not belongs to the specified group
      MEDIA_TOPIC_BLOCK_LIMIT               = 600 # Too many media parameters
      MEDIA_TOPIC_TEXT_LIMIT                = 601 # Text limit reached
      MEDIA_TOPIC_POLL_QUESTION_TEXT_LIMIT  = 602 # Question text limit reached
      MEDIA_TOPIC_POLL_ANSWERS_LIMIT        = 603 # Too many answer parameters
      MEDIA_TOPIC_POLL_ANSWER_TEXT_LIMIT    = 604 # Answer text limit reached
      MEDIA_TOPIC_WITH_FRIENDS_LIMIT        = 605 # Pinned friends count limit reached
      MEDIA_TOPIC_WITH_FRIENDS_USER_LIMIT   = 606 # Pinned friends count limit reached (user-specific)
      GROUP_DUPLICATE_JOIN_REQUEST          = 610 # Group join request already registered.
      COMMENT_NOT_FOUND                     = 700 # Comment not found
      INVALID_AUTHOR                        = 701 # Invalid author
      COMMENT_NOT_ACTIVE                    = 702 # Comment was removed
      TIMEOUT_EXCEEDED                      = 704 # Edit timeout exceeded
      CHAT_NOT_FOUND                        = 705 # Chat not found
      MESSAGE_NOT_ACTIVE                    = 706 # Message was removed
      NO_SUCH_APP                           = 900 # Returned, when try to get public application information for not existing application
      CALLBACK_INVALID_PAYMENT              = 1001 # Error returned by the application server to notify about invalid transaction details
      PAYMENT_IS_REQUIRED_PAYMENT           = 1002 # Payment is required to use service
      INVALID_PAYMENT                       = 1003 # Invalid payment transaction
      DUPLICATE_PAYMENT                     = 1004 # Instant payment is too frequent
      NOT_ENOUGH_MONEY                      = 1005 # User has no requested amount of money on his account
      VCHAT_SERVICE_DISABLED                = 1101 # Video chat is disabled.
      TARGET_USER_UNAVAILABLE               = 1102 # Target user is not available for video chat or video message/
      FRIENDSHIP_REQUIRED                   = 1103 # Target user must be a friend.
      BATCH                                 = 1200 # Batching error.
      APP_NO_PLATFORM_ALLOWED               = 1300 # No platforms allowed for this application
      APP_DEVICE_NOT_ALLOWED                = 1301 # Specified device not allowed
      APP_DEVICE_NOT_SPECIFIED              = 1302 # Device not specified
      APP_EMPTY_SEARCH_PARAMS               = 1400 # Location search error.
      APP_SEARCH_SCENARIO_DOES_NOT_EXIST    = 1401 # Location search error.
      SYSTEM                                = 9999 # Critical system error. Please report these problems support
    end

    class << self
      # Create a new error from an HTTP response
      #
      # @param response [HTTP::Response]
      # @return [Odnoklassniki::Error]
      def from_response(body)
        new(*parse_error(body))
      end

      private

      def parse_error(body)
        [body['error_msg'].to_s, body['error_code']]
      end

    end

    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param code [Integer]
    # @return [Odnoklassniki::Error]
    def initialize(message = '', code = nil)
      super(message)
      @code = code
    end
  end
end
