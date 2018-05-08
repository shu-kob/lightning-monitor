require 'net/http'
require 'json'

class LightningController < ApplicationController
    def index
        @getinfo = `cd ~/lightning && cli/lightning-cli getinfo`
        @getinfo_json = JSON.parse(@getinfo)

        @listpeers = `cd ~/lightning && cli/lightning-cli listpeers`
        peers_json = JSON.parse(@listpeers)
        @peers_json = peers_json['peers']

        @listfunds = `cd ~/lightning && cli/lightning-cli listfunds`

        @listnodes = `cd ~/lightning && cli/lightning-cli listnodes`
        nodes_json = JSON.parse(@listnodes)
        @nodes_json = nodes_json['nodes']

        render template: 'lightning/index'
    end
end
