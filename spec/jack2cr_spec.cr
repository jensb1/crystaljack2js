require "./spec_helper"

describe Jack2 do
  # TODO: Write tests

  it "works" do
    client = Jack2::Client.new
    client.register_port("out", Jack2::Client::PORT_OUTPUT)
    puts client.ports
  end
end
