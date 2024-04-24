# README

## Fantasy League Chat Bot

This is a telegram bot that allows users to create and manage Telegram games. 

The bot allows users to create your own games via standard JSON files(see the examples in the `lib/assets/games` folder), and then play them with friends.

The bot is built using the telegram-bot-ruby gem and the Rails framework.
CQRS and Event Sourcing are used to manage the state of the games and the interactions with the users.

# local env
```bash
# install dependencies

bundle install

# setup database

rails db:setup

rake bonuses:create
rake strategies:create
rake users:create

# run server

rake telegram:bot:poller
```


follow the instructions in the telegram bot to interact with the bot: [@FantasyLeagueChatBot](https://t.me/FantasyLeagueChatBot)
