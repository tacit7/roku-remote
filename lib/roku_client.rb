require 'httparty'
require 'open-uri'

module RokuRemote
  COMMANDS = %w| Home Rev Fwd Play Select Left Right
                 Down Up Back InstantReplay Info
                 Backspace Search Enter |

  class Client
    RokuQueryError = Class.new(StandardError)
    PORT = '8060'

    def initialize(ip = nil)
      @ip = ip
    end

    def query_apps
      HTTParty.get "#{base_url}query/apps"
    end

    def keypress(command)
      if authorized_command? command
        HTTParty.post "#{base_url}keypress/#{command}"
      else
        # raise RokuQueryError, "the command '#{command}' is not recognized"
      end
    end

    def keydown(command)
      if authorized_command? command
        HTTParty.post "#{base_url}keyup/#{command}"
      else
        # raise RokuQueryError, "the command '#{command}' is not recognized"
      end
    end

    def keyup(command)
      if authorized_command? command
        HTTParty.post "#{base_url}keyup/#{command}"
      else
        # raise RokuQueryError, "the command '#{command}' is not recognized"
      end
    end

    def launch(app_id)
      HTTParty.post "#{base_url}launch/#{app_id}"
    end

    def send_char(char)
      char = URI::encode(char)
      if char == "%7F"
        keypress 'Backspace'
      elsif char == "%0D"
        keypress 'Enter'
      else
        HTTParty.post "#{base_url}keypress/Lit_#{char}"
      end
    end
    private

    def base_url
      "http://#{@ip}:#{PORT}/"
    end

    def authorized_command?(command)
      COMMANDS.include?(command)
    end
  end
end
