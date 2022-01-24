require_relative "./config"

require "google/apis/admin_directory_v1"
require "googleauth"

def fetch_authorizer!(scope: nil)
    raise "Scope needs to be defined" if scope.to_s.empty?

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope:       scope)

    authorizer.sub = ADMIN_EMAIL

    authorizer.fetch_access_token!

    authorizer
end

def init_service(authorizer: nil)
    raise "Initialize the authorizer firts" unless authorizer


    Google::Apis::AdminDirectoryV1::DirectoryService.new.tap do |service|
        service.authorization = authorizer
    end
end
