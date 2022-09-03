require "terminal-table"
module Presenter
  def print_welcome
    # print the welcome message
    ["###################################",
     "#   Welcome to Clivia Generator   #",
     "###################################"]
  end

  def print_score(score)
    # print the score message
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score"]
    table.rows = score.map do |scor|
      [scor[:name], scor[:score]]
    end
    table
  end
end
