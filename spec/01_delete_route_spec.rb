require "spec_helper"

RSpec.describe "DELETE /ratingQuestions/:id" do
  def app
    Application
  end
  
  context "with an existing question" do
    let(:question) do
      response = post("/ratingQuestions", { title: "Hello World" }.to_json)
      JSON.parse(response.body)
    end

    let(:response) do
      delete("/ratingQuestions/#{question["id"]}")
    end

    it "returns a 204 No Content" do
      expect(response.status).to eq(204)
    end

    it "returns nothing" do
      expect(response.body.to_s).to eq('')
    end
  end

  context "asking to delete a question that doesn't exist" do
    let(:response) do
      delete("/ratingQuestions/i-will-never-exist")
    end

    it "returns a 404 Not Found" do
      expect(response.status).to eq(404)
    end
  end
end
