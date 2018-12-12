# This is tweaked from the examples on https://github.com/meew0/discordrb/tree/master/examples

require 'json'
require 'discordrb'

# Authorizes the bot with a hidden token in .config
bot = Discordrb::Bot.new token: JSON.parse(File.read('.config'))['token']

# This method call adds an event handler that will be called on any message
# that exactly contains the string "Ping!".
# The code inside it will be executed, and a "Pong!" response will be sent.
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

# This method call has to be put at the end of your script,
# it is what makes the bot actually connect to Discord. If you
# leave it out the script will simply stop and the bot will not appear online.
bot.run
