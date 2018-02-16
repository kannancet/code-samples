require "spec_helper"

RSpec.describe Stockman::User do

  subject { Stockman::User.new }
  it { should have_attr_accessor(:name) }

end
