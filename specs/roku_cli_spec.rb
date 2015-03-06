require 'rspec'
require_relative '../lib/roku_cli.rb'

describe "RokuRemote::Cli" do
  describe '#key_dispatch' do
    let(:cli) { RokuRemote::Cli.new }
    context "when 'j' is pressed" do
      it 'should request Down' do
        expect(cli.client).to receive(:keypress).with('Down')
        cli.key_dispatch 'j'
      end
    end
    context "when 'k' is pressed" do
      it 'should request Up' do
        expect(cli.client).to receive(:keypress).with('Up')
        cli.key_dispatch 'k'
      end
    end
    context "when 'l' is pressed" do
      it 'should request Left' do
        expect(cli.client).to receive(:keypress).with('Right')
        cli.key_dispatch 'l'
      end
    end
    context "when 'h' is pressed" do
      it 'should request Left' do
        expect(cli.client).to receive(:keypress).with('Left')
        cli.key_dispatch 'h'
      end
    end
    context "when 'return' is pressed" do
      it 'should request Select' do
        expect(cli.client).to receive(:keypress) {'Select'}
        cli.key_dispatch "\r"
      end
    end

    context "when 'space' is pressed" do
      it 'should request Play' do
        expect(cli.client).to receive(:keypress) {'Play'}
        cli.key_dispatch ' '
      end
    end
  end
end
