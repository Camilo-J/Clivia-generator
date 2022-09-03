module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = ["random", "scores", "exit"]
    action = ""
        puts options.join(" | ")
        print "> "
        action = gets.chomp
        action.downcase
  end

  def ask_question(question)
    # show category and difficulty from question
    puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
    # show the question
    puts "Question: #{question[:question]}"
    # show each one of the options
    # p question[:correct_answer]
    answer = question[:incorrect_answers].push(question[:correct_answer])
    # grab user input
    gets_option(answer.shuffle())
  end

  def will_save?(score)
    # show user's score
    puts "-"*50
    puts "Well done! Your score is #{score}"
    # ask the user to save the score
    puts "Do you want to save your score? (y/n)"
    print "> "
    # grab user input
    answer = gets.chomp
    if answer.downcase == "y"
      puts "Type the name to assign to the score"
      print "> "
      name = gets.chomp
      name = "Anonymous" if name.empty?
      {name: name, score: score}
    end     
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end
  #gets_option(prompt, options)
  def gets_option(options)
    options.each_with_index {|answer, index| puts "#{index+1}. #{answer}"}
    # puts "#{options}"
    print "> "
    answer = gets.chomp
    #options.include?(action)
    return nil if answer.empty?
    options[answer.to_i-1]
  end
end
