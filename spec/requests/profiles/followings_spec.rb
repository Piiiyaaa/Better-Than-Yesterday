require 'rails_helper'

RSpec.describe "Profiles::Followings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/profiles/followings/index"
      expect(response).to have_http_status(:success)
    end
  end
end
