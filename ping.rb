# This is tweaked from the examples on https://github.com/meew0/discordrb/tree/master/examples

require 'json'
require 'discordrb'

# Authorizes the bot with a hidden token in .config
bot = Discordrb::Bot.new token: JSON.parse(File.read('.config'))['token']

# This method call adds an event handler that will be called on any message
# that exactly contains the string "Ping!".
# The code inside it will be executed, and a "Pong!" response will be sent.
bot.message(content: 'Ping!') do |event|
  # The `respond` method returns a `Message` object, which is stored in a
  # variable `m`. The `edit` method is then called to edit the message with the
  # time difference between when the event was received and after the message
  # was sent.
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

# The `mention` event is called if the bot is *directly mentioned*, i.e. not
# using a role mention or @everyone/@here.
bot.mention do |event|
  # The `pm` method is used to send a private message (also called a DM or
  # direct message) to the user who sent the initial message.
  event.user.pm('You have mentioned me!')

  event.respond("You have mentioned me: @#{event.user.username}##{event.user.discriminator}")
end

# This method call has to be put at the end of your script,
# it is what makes the bot actually connect to Discord. If you
# leave it out the script will simply stop and the bot will not appear online.
bot.run
