require "spec_helper"

RSpec.describe "PATCH /ratingQuestions/:id" do
  def app
    Application
  end
  
  context "when the question exists" do
    let(:question) do
      response = post("/ratingQuestions", { title: "Hello World" }.to_json)
      JSON.parse(response.body)
    end

    let(:response) { patch("/ratingQuestions/#{question["id"]}", { tag: "greetings" }.to_json)}

    it "returns a 200 OK" do
      expect(response.status).to eq(200)
    end

    it "returns a question -- with an additional field" do
      question = JSON.parse(response.body)
      expect(question.is_a?(Hash)).to eq(true)
      expect(question["title"]).to eq("Hello World")
      expect(question["tag"]).to eq("greetings")
    end
  end

  context "asking to get a question that doesn't exist" do
    let(:response) do
      patch("/ratingQuestions/i-will-never-exist", { title: "not here"}.to_json)
    end

    it "returns a 404 Not Found" do
      expect(response.status).to eq(404)
    end
  end
end