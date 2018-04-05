module Request
  module JsonResponseHelper
    def js_response symbolize_keys: true
      JSON.parse(response.body, symbolize_names: symbolize_keys)
    end
  end
end
