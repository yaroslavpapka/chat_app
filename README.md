# Elixir Chat Application

This project is a simple chat application built using Elixir, designed to allow users to connect to specific chat rooms and exchange messages with a group of users. It uses the following libraries for implementation:

- [N2O](https://github.com/synrc/n2o)
- [Nitro](https://github.com/synrc/nitro)

## Features

1. **Multiple Chat Rooms**  
   - The home page contains three buttons: **"Room 1"**, **"Room 2"**, and **"Room 3"**.
   - Clicking on one of the buttons redirects the user to the selected chat room.

2. **Message Input and Broadcasting**  
   - Inside a chat room, users can see:
     - A message input field.
     - A "Send" button to submit their messages.
     - A panel displaying messages from all users in the same room.
   - When a user sends a message, the server broadcasts it to all users currently in the same room.

## Requirements

- **Elixir** 
- Libraries: [N2O](https://github.com/synrc/n2o), [Nitro](https://github.com/synrc/nitro)

## Getting Started

1. Clone this repository:
2. Run "mix deps.get"
3. Start application "iex -S mix" 