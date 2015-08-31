=begin
  Test to desribe Main spec
=end
require "spec_helper"

describe DhhScore::Calculator do 

  before do
  	@dhh_score = DhhScore::Calculator.new
  	@github_url = "https://api.github.com/users/dhh/events/public"
  end

  it "Should initialize the Calculator class" do
  	expect(@dhh_score.kind_of? DhhScore::Calculator).to eq true
  	expect(@dhh_score.github_url).to eq @github_url
  	expect(@dhh_score.event_slab.kind_of? Hash).to eq true
  end

  it "Should calculate the score" do
  	expect { @dhh_score.calculate_score}.to change { @dhh_score.score }.from(0).to(162)
    expect(@dhh_score.calculate_score.kind_of? Integer).to eq true
  end

  it "Should run the program" do
  	output = @dhh_score.run
    expect(output.include?("DHH's github score is")).to eq true
  end
end