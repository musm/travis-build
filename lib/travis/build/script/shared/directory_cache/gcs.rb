require 'shellwords'

require 'travis/build/script/shared/directory_cache/base'
require 'travis/build/script/shared/directory_cache/signatures/aws2_signature'

module Travis
  module Build
    class Script
      module DirectoryCache
        class Gcs < Base
          DATA_STORE = :gcs
          SIGNATURE_VERSION = '2'

          def host_proc
            Proc.new do |region|
              'storage.googpleapis.com'
            end
          end

          def push
            signer.write_curl_config_to(File.expand_path('curl_headers', ENV['HOME']))
            super
          end
        end
      end
    end
  end
end
