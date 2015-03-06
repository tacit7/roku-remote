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
        client.keyup 'Home'
      end
    end
  end
end
