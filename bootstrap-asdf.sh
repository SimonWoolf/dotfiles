#!/bin/sh
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
