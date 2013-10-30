# XXX :
# Register our own media-type. For testing purpose we're dealing with two versions.
Mime::Type.register "application/vnd.azendoo+json; version=1", :API_V1, %w( application/vnd.azendoo+json )
Mime::Type.register "application/vnd.azendoo+json; version=2", :API_V2

# XXX : we remove default XML parser.
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)

# XXX : We set default parser of our media-types to JSON :
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::API_V1] = :json
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::API_V2] = :json

