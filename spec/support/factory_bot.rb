# frozen_string_literal: true

def json_parse
  JSON.parse(response.body)
end
def json_collection
  json_parse['']
end
def json_item

end