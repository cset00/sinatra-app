require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'json'
require_relative 'environment'

def rating_questions 
  RatingQuestion.all.to_a
end

before do
  content_type :json
  response['Access-Control-Allow-Origin'] = 'http://localhost:3000'
  response['Access-Control-Allow-Methods'] = 'GET,HEAD,PUT,PATCH,POST,DELETE'
  response['Access-Control-Allow-Credentials'] =  'true'
  response['Access-Control-Allow-Headers'] =  'content-type'
end

options '*' do
  200
end

def write_to_db(object)
  File.open('db.json', "w") do |f|
    f.write(JSON.pretty_generate({ratingQuestions: object}))
  end
end

def send_response(response, status, body)
  response.status = status
  response.body = body.to_json
  response
end

def serialize_question(question)
  {
    id: question.id.to_s,
    title: question.title
  }
end

post '/ratingQuestions' do
  error = {"errors"=>{"title"=>["cannot be blank"]}}
  binding.pry
  return send_response(response, 400, error) if request.params.size.zero?
  
  return send_response(response, 422, error) if request.params["title"] == ""
  
  new_rating_question = RatingQuestion.create(
    title: request.params["title"]
  )

  send_response(response, 201, new_rating_question) 
end

delete '/ratingQuestions/:id' do
  q_to_del = RatingQuestion.find_by(_id: params["id"])

  return send_response(response, 404,{}) if !q_to_del

  q_to_del.destroy
  
  send_response(response, 204, {})
end

get '/ratingQuestions' do
  new_rating_questions = RatingQuestion.all.map do |question|
    serialize_question(question)
  end

  send_response(response, 200, new_rating_questions)
end

get '/ratingQuestions/:id' do
  the_q = RatingQuestion.find_by(_id: params["id"])
  
  return send_response(response, 404,{}) if !the_q
  send_response(response, 200, the_q)
end

patch '/ratingQuestions/:id' do
  return send_response(response, 404, {}) if request.params.size.zero?
  
  q_to_update = RatingQuestion.find_by(_id: params["id"])
  return send_response(response, 404,{}) if q_to_update == nil

  RatingQuestion.update(_id: params["id"], title: request.params["title"], upsert: true)

  send_response(response, 200, q_to_update)
end
