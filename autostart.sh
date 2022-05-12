#!/bin/bash

if (xrdb -query | grep -q "^awesome\\.started:\\s*true$") then
  exit
fi

xrdb -merge <<< "awesome.started:true"
dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"
