# do not forget to require your gem dependencies
require "httparty"
require "htmlentities"
# do not forget to require_relative your local dependencies
require_relative "presenter"
require_relative "requester"
class CliviaGenerator
  attr_reader :coder
  # maybe we need to include a couple of modules?
  include Presenter
  include Requester
  def initialize
    # we need to initialize a couple of properties here
    @file = ARGV.shift || "scores.json"
    @response = nil
    @coder = HTMLEntities.new
    @question = nil
    #coder.decode(string) 
  end

  def start
    # welcome message
    p @file
    ARGV.shift
    puts print_welcome
    # prompt the user for an action
    select_main_menu_action
    random_trivia
    # keep going until the user types exit
  end

  def random_trivia
    # load the questions from the api
    load_questions
    parse_questions
    # questions are loaded, then let's ask them
    ask_questions
  end

  def ask_questions
    # ask each question
    indi = 0
    while indi < 10
      data_ques = @question[indi]
      ask_question(data_ques)
      indi += 1 
    end
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    @response = JSON.parse(response.body, symbolize_names: true)
    # then parse the questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
    results_got = @response[:results]
    @question = results_got.each do |result|
    result[:question] =  coder.decode(result[:question])
    # test to decode incorrect answer
    # result[:incorrect_answer] = result[:incorrect_answers].map{ |ans| coder.decode(ans) }
    end
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end

trivia = CliviaGenerator.new
trivia.start
