require_relative "dhh_score/version"
require_relative "dhh_score/dependencies"

module DhhScore

=begin
  This class is used to calculate DHH score
  It initiates with an API url.
=end
  class Calculator

    attr_accessor :github_url, :event_slab, :score

=begin
    This fucntion Initialize Dhh Score
=end
    def initialize
      @github_url = "https://api.github.com/users/dhh/events/public"
      @event_slab = {"IssuesEvent": 7,
               "IssueCommentEvent": 6,
               "PushEvent": 5,
               "PullRequestReviewCommentEvent": 4,
               "WatchEvent": 3,
               "CreateEvent": 2,
               "Any other event": 1
              }
      @score = 0
    end

=begin
    This function is used to parse data from API
=end
    def calculate_score
      @data = JSON.parse(open(github_url).read)
      @score = @data.inject(0) do |result, data|
               type = data["type"].to_sym

         if @event_slab.has_key? type
           result += @event_slab[type]
               else
           result += @event_slab[:"Any other event"]
         end
                   
           result
         end
    end

=begin
    This function is used to run program
=end
    def run
      begin
        calculate_score
        "DHH's github score is #{@score}"

      rescue Exception => e
        p e.message
      end
    end

  end
end

@test = DhhScore::Calculator.new
p @test.run
