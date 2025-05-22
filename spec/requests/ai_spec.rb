require 'rails_helper'

RSpec.describe "Ais", type: :request do
  describe "GET /generate_question" do
    it "returns http success" do
      get "/ai/generate_question"
      expect(response).to have_http_status(:success)
    end
  end
end
