require "JSON"
module Helpers
    module JSON_parser
        def json_parser(body)
            JSON.parse(body)
        end
    end
end