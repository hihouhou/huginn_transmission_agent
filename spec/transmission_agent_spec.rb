require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::TransmissionAgent do
  before(:each) do
    @valid_options = Agents::TransmissionAgent.new.default_options
    @checker = Agents::TransmissionAgent.new(:name => "TransmissionAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
