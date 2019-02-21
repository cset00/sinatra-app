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

  # you do not need this as we are not writing on json file anymore. 

  # def write_to_db(object)
  #   File.open('db.json', "w") do |f|
  #     f.write(JSON.pretty_generate({ratingQuestions: object}))
  #   end
  # end

  # response is global so you do not need to pass it as argument
  #you car write it like that 

  # def send_response(status, body)
  #   response.status = status
  #   response.body = body.to_json
  #   response
  # end

  def send_response(status, body)
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
    body = request.body.read

    return send_response(400, nil) if body.size.zero?
 
    json_params = JSON.parse(body)
    
    new_rating_question = RatingQuestion.new(
      title: json_params["title"],
      tag: json_params["tag"]
    )

    if new_rating_question.save
      send_response(201, serialize_question(new_rating_question))
    else
      errors = { 'errors' => new_rating_question.errors.messages }
      send_response(422, errors)
    end

  end

  delete '/ratingQuestions/:id' do
    q_to_del = RatingQuestion.find(params["id"])

    return send_response(404,{}) if !q_to_del

    q_to_del.destroy
    
    send_response(204, {})
  end

  get '/ratingQuestions' do
    new_rating_questions = RatingQuestion.all.map do |question|
      serialize_question(question)
    end

    send_response(200, new_rating_questions)
  end

  get '/ratingQuestions/:id' do
    the_q = RatingQuestion.find_by(_id: params["id"])
    
    return send_response(404,{}) if !the_q
    send_response(200, serialize_question(the_q))
  end

  patch '/ratingQuestions/:id' do
    id = params["id"]
    body = request.body.read

    if body.size.zero?
      return send_response(404, {}) 
    end

    json_params = JSON.parse(body)

    q_to_update = RatingQuestion.find(id)

    return send_response(404,{}) if q_to_update.nil?


    q_to_update.update(json_params)

    send_response(200, serialize_question(q_to_update))
  end

end


