# encoding: UTF-8
# XXX :
# Customization of ActionDispatch's MIME type negotation.
# The following modification allows us to default on application/json type
# if Content-Type header of a HTTP request isn't supported (cf. whitelist).
module ActionDispatch
  module Http
    module MimeNegotiation


      MIME_TYPES_WHITELIST ||= [ Mime::ALL, Mime::JSON, Mime::API_V1,
                                 Mime::API_V2, '' ]

      def content_mime_type
        @env["action_dispatch.request.content_type"] ||= begin
          if @env['CONTENT_TYPE'] =~ /^([^,\;]*)/
            if MIME_TYPES_WHITELIST.include?($1)
              Mime::Type.lookup($1.strip.downcase)
            else
              Mime::JSON
            end
          else
            nil
          end
        end
      end

    end
  end
end

