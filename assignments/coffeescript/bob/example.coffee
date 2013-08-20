class Bob
    hey: (message) -> switch
        when message.trim() == "" then "Fine. Be that way!"
        when message == message.toUpperCase() then "Woah, chill out!"
        when message[message.length - 1] == "?" then "Sure."
        else "Whatever."
module.exports = Bob
