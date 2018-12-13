# This is tweaked from the examples on https://github.com/meew0/discordrb/tree/master/examples

require 'json'
require 'discordrb'

# the unicode ":x:" emoji
CROSS_MARK = "\u274c".freeze

# Authorizes the bot with a hidden token in .config
bot = Discordrb::Bot.new token: JSON.parse(File.read('.config'))['token']

# Upon recieving --help, do this...
bot.message(content: '--help') do |event|
  # Send message, and store it that we can issue a delete request later
  message = event.respond %(
    Hello! This is a test bot.\n
    The time is: #{Time.now.strftime('%F %T %Z')}.\n
    If you click the #{CROSS_MARK}, this message will disappear.
  )

  # React to the message to give a user an easy "button" to press
  message.react CROSS_MARK

  # Add an await for a ReactionAddEvent, that will only trigger for reactions
  # that match our CROSS_MARK emoji. This time, I'm using interpolation to make
  # the await key unique for this event so that multiple awaits can exist.
  bot.add_await(
    :"delete_#{message.id}",
    Discordrb::Events::ReactionAddEvent,
    emoji: CROSS_MARK
  ) do |reaction_event|
    # Since this code will run on every CROSS_MARK reaction, it might not
    # be on our time message we sent earlier. We use `next` to skip the rest
    # of the block unless it was our message that was reacted to.
    next true unless reaction_event.message.id == message.id

    # Delete the matching message.
    message.delete
  end
end

# This method call has to be put at the end of your script,
# it is what makes the bot actually connect to Discord. If you
# leave it out the script will simply stop and the bot will not appear online.
bot.run
