require 'sinatra/base'
require 'sinatra/reloader'
require 'pry'
require 'json'
require_relative 'environment'

class Application < Sinatra::Base
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
      title: question.title,
      tag: question.tag
    }
  end

  post '/ratingQuestions' do
    errors = {"errors"=>{"title"=>["can't be blank"]}}

    # binding.pry

    
    body = request.body.read
 
    if body.size.zero?
      return send_response(response, 400, errors) 
    end
    
    json_params = JSON.parse(body)
    
    new_rating_question = RatingQuestion.new(
      title: json_params["title"],
      tag: json_params["tag"]
    )

    if new_rating_question.save
      send_response(response, 201, serialize_question(new_rating_question))
    else
      # errors = { 'errors' => new_rating_question.errors.messages }
      send_response(response, 422, errors)
    end

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
    send_response(response, 200, serialize_question(the_q))
  end

  patch '/ratingQuestions/:id' do
    id = params["id"]
    body = request.body.read

    if body.size.zero?
      return send_response(response, 404, {}) 
    end

    json_params = JSON.parse(body)

    q_to_update = RatingQuestion.find(id)
    return send_response(response, 404,{}) if q_to_update == nil

    q_to_update.update(json_params)

    send_response(response, 200, serialize_question(q_to_update))
  end

  run! if app_file == $0
end


