# do not forget to require your gem dependencies
require "httparty"
require "htmlentities"
require "json"
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
    @score = 0 
  end

  def start
    # welcome message
    ARGV.shift
    action = ""
    # prompt the user for an action
    # keep going until the user types exit
    until action == "exit"
      puts print_welcome
      action = select_main_menu_action
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      when "exit" then puts "Thanks for using Clivia"
      else
        puts "Invalid option"
      end
    end
  end

  def random_trivia
    # load the questions from the api
    load_questions
    parse_questions
    # questions are loaded, then let's ask them
    data = ask_questions
    save(data) if data.is_a?(Hash)
  end

  def ask_questions
    # ask each question
    indi = 0
    while indi < 10
      data_ques = @question[indi]
      answer =  ask_question(data_ques)
      # if response is correct, put a correct message and increase score
      # if response is incorrect, put an incorrect message, and which was the correct answer
      if answer == data_ques[:correct_answer]
        puts  "#{answer}... Correct!"
        puts  "You win 10 points"
        puts  "-" * 20
        @score += 10
      else
        puts  "#{answer}... Incorrect!"
        puts "The correct answer was: #{data_ques[:correct_answer]}"
        puts  "-" * 20
      end
      indi += 1 
    end
    # once the questions end, show user's score and promp to save it
    will_save?(@score)
  end

  def save(data)
    # write to file the scores data
    @score = 0
    #  File.write(@file, JSON.dump(data),mode: "a+")
    begin
      File.write(@file,[].to_json) if File.read(@file).empty?
    rescue #=> Errno::Enoent
      File.write(@file,[].to_json)
    end
    data_parse = JSON.parse(File.read(@file), symbolize_names: true)
    File.open(@file,"w") { |f| f.write((data_parse.push(data)).to_json) }
  end

  def parse_scores
    # get the scores data from file
    scores = JSON.parse(File.read(@file), symbolize_names: true)
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
    # test to decode incorrect answer and correct answer
    result[:correct_answer] = coder.decode(result[:correct_answer] )
    result[:incorrect_answer] = result[:incorrect_answers].map{ |ans| coder.decode(ans) }
    end
  end

  def print_scores
    # print the scores sorted from top to bottom
    score = parse_scores
    puts print_score(score)
  end
end

trivia = CliviaGenerator.new
trivia.start
