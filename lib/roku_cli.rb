require_relative '../lib/roku_client'
require 'pry'
module RokuRemote
  class Cli
    CTRL_T = "\u0014"
    SPC    = ' '
    ESC    = '\e'
    attr_reader :client
    DEFAULT_COMMAND_MAP = {
      'k' => 'Up',
      'j' => 'Down',
      'l' => 'Right',
      'h' => 'Left',
      "\r" => 'Select',

      SPC => 'Play',
      'r' => 'Rev',
      'f' => 'Fwd',
      'i' => 'InstantReplay',

      'H' => 'Home',
      'I' => 'Info',
      'b' => 'Back',
      '/' => 'Search',
      
      'a' => 'ListApps', # Value is not a roku defined keypress command. Its a handle for this gem.
      'g' => 'GoToBookmark',
      'G' => 'AddBookmark',
      '?' => 'Help',
      CTRL_T => 'SendText'
    }

    def initialize(ip = nil, user_defined_map  = {}, bookmarks = {})
      @ip = ip.nil? ? get_ip : ip
      @client = RokuRemote::Client.new(@ip)
      @user_defined_map = user_defined_map
      @bookmarks = bookmarks
    end

    def command_map
      @command_map ||= DEFAULT_COMMAND_MAP.merge @user_defined_map
    end

    def select_available_app
      display_available_apps
      puts ''
      puts 'Enter the app id(esc to cancel):'
      app_id = gets.chomp
      return if app_id == ESC
      @client.keypress 'Home'
      @client.launch app_id
    end

    def display_available_apps
      payload = @client.query_apps
      payload['apps']['app'].each do |app| 
        puts " #{app['id']} \t #{app['__content__']}"
      end
    end

    def read_char
      system "stty raw -echo"
      STDIN.getc
    ensure
      system "stty -raw echo"
    end 

    def start
      char = nil 
      until char == 'q'
        char = read_char
        
        gem_ctrl_chars(char) || roku_key_dispatch(char)
      end
    end

    def roku_key_dispatch(key)
      return select_available_app if command_map[key] == 'ListApps'
      @client.keypress command_map[key]
    end

    def get_ip
      puts " Please enter your Roku IP:"
      gets.chomp  
    end

    def gem_ctrl_chars(char)
      case command_map[char]
      when 'Help'
        help
      when 'SendText'
        start_sending_text
      when 'AddBookmark'
        add_bookmark
      when 'GoToBookmark'
        go_to_bookmark
      end
    end  

    def bookmarks_path
      home_path = File.expand_path '~'
      @bookmarks_path = File.join(home_path, '.roku_remote_bookmarks.rb')
    end

    def save_bookmarks
      File.open(bookmarks_path, 'r+') do |f|
        f.write "IP = #{'@ip'}"
        f.write "MAP = #{command_map.inspect}"
        f.write "BOOKMARKS = #{@bookmarks.inspect}"
      end
    end

    def go_to_bookmark
      puts ''
      display_current_bookmarks
      puts ''
      key = read_char
      
      @client.keypress 'Home'
      @client.launch bookmark_app_id(key)
    end

    def bookmark_app_id(key)
      @bookmarks[key][1]
    end
    
    def display_current_bookmarks
      puts ' '
      return puts 'No Bookmarks' if @bookmarks.empty?
      puts '_________ Current Bookmarks ___________'

      @bookmarks.each do |key, name_and_app_id|
        name   = name_and_app_id[0]
        app_id = name_and_app_id[1]
        puts " #{key} \t #{name} (#{app_id})"
      end
    end

    def add_bookmark
      puts ''
      puts '_________ Available Apps _____________'
      display_available_apps
      puts ''
      display_current_bookmarks
      puts '______________________________________'

      print 'Enter shortcut key:'
      key = gets.chomp

      print '                   '
      print 'Enter app id:'
      id = gets.chomp

      puts 'Enter bookmark name:'
      name = gets.chomp

      save_bookmark id, key, name 
    end

    def save_bookmark(id, key, name)
      @bookmarks[key] = [name, id]
      save_bookmarks
    end

    def start_sending_text
      puts ''
      puts 'Start sending text to roku'
      char = nil
      until char == CTRL_T
        char = read_char
        next if (char == CTRL_T || char == "\r")
        @client.send_char char
      end
      puts 'End sending text to roku'
      puts ''
      true
    end

    def help

      puts <<HELP
Keymap:
  q       Quit

  k       Up
  j       Down
  h       Right
  l       Left
  Return  Select

  i       Rev
  o       Fwd
  Space   Play

  H       Home
  B       Back
  R       Instat Replay
  I       Info
  /       Search

  G<char> Set bookmark at <char>
  g<char> Go to bookmark set at <char>
  a       Go to app
  C-t     Toggle send text
HELP
      true
    end
  end
end
