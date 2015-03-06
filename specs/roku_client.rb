require 'rspec'
require_relative '../lib/roku_client.rb'

describe "RokuClient" do

  let(:client) { RokuRemote::Client.new }
  context "For supported URLs" do
    describe "query/apps" do

      it "should make a GET request" do
        expect(HTTParty).to receive(:get)
        client.query_apps
      end
    end

    describe "keypress" do

      it "should make a POST request" do
        expect(HTTParty).to receive(:post)
        client.keypress 'Home'
      end
    end

    describe "keydown" do

      it "should make a POST request" do
        expect(HTTParty).to receive(:post)
        client.keydown 'Home'
      end
    end
    
    describe "keyup" do

      it "should make a POST request" do
        expect(HTTParty).to receive(:post)
        query.keyup 'Home'
      end
    end
  end
  #   This
  #   'query/apps' returns a map of all the channels installed on the Roku box paired with their app id.
  #     This command is accessed via an http GET.

  #   keydown
  # followed by a slash and the name of the key pressed
  # This command is sent via a POST with no body
  # Keydown is equivalent to pressing down the remote key whose value is the argument passed

  # keyup
  # followed by a slash
  # the name of the key to release
  # This command is sent via a POST with no body
  # Keyup is equivalent to releasing the remote key whose value is the argument passed. 

  # keypress
  # followed by a slash
  # the name of the key pressed
  # Keypress is equivalent to pressing down and releasing the remote key whose value is the argument passed
  # This command is sent via a POST with no body

  # launch
  # followed by a slash
  # app id
  # optionally followed by a question mark
  # list of URL parameters that are sent to the app id as an roAssociativeArray passed to the RunUserInterface() or Main() entry point
  # This command is sent via a POST with no body.

  # query/icon
  # followed by a slash
  # app id
  # returns an icon corresponding to that app.
  #   The binary data with an identifying MIME-type header is returned
  # This command is accessed via an http GET.
  
end
