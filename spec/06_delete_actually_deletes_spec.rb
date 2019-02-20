require "spec_helper"

# RSpec.describe "DELETE /ratingQuestions/:id" do
#   def app
#     Application
#   end

#   before do
#     header 'Content-Type', 'application/json'
#   end
  
#   context "with an existing question" do
#     let(:question) do
#       response = post("/ratingQuestions", { title: "Hello World" })
#       binding.pry
#       response.parse
#     end

#     it "actually deletes the question" do
#       route = "/ratingQuestions/#{question["id"]}"
#       HTTP.delete(route)
#       response = HTTP.get(route)
#       expect(response.status).to eq(404)
#     end
#   end
# end

#from Tanim
RSpec.describe "DELETE /ratingQuestions/:id" do
  def app
    Application
  end

  # before do
  #   header 'Content-Type', 'application/json'
  # end
  
  context "with an existing question" do
    json = { title: "Hello World" }.to_json

    it "actually deletes the question" do
      post("/ratingQuestions", json, { 'CONTENT_TYPE' => 'application/json' })
      body = JSON.parse(last_response.body)
      route = "/ratingQuestions/#{body["id"]}"
      delete route
      get route
      expect(last_response.status).to eq(404)
    end
  end
end
