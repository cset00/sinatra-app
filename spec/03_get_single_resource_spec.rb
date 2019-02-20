require "spec_helper"

RSpec.describe "GET /ratingQuestions/:id" do
  def app
    Application
  end
  
  context "when the question exists" do
    let(:question) do
      response = post("/ratingQuestions", { title: "Hello World" }.to_json)
      JSON.parse(response.body)
    end

    let(:response) { get("/ratingQuestions/#{question["id"]}") }

    it "returns a 200 OK" do
      expect(response.status).to eq(200)
    end

    it "returns a question" do
      expect(JSON.parse(response.body).is_a?(Hash)).to eq(true)
    end
  end

  context "asking to get a question that doesn't exist" do
    let(:response) do
      get("/ratingQuestions/i-will-never-exist")
    end

    it "returns a 404 Not Found" do
      expect(response.status).to eq(404)
    end
  end
end
