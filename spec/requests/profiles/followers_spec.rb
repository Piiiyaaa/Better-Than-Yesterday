require 'rails_helper'

RSpec.describe "Profiles::Followers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/profiles/followers/index"
      expect(response).to have_http_status(:success)
    end
  end
end
