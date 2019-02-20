require 'spec_helper'

RSpec.describe "GET /ratingQuestions" do
  def app
    Application
  end

  it "returns a 200 OK" do
    get("/ratingQuestions")
    expect(last_response.status).to eq(200)
  end

  it "returns an array" do
    get("/ratingQuestions")
    expect(JSON.parse(last_response.body).is_a?(Array)).to eq(true)
  end
end
