require 'bitcoin'
require 'openassets'
require 'net/http'
require 'json'
Bitcoin.network = :testnet3
RPCUSER = "shu"
RPCPASSWORD = "ubuntu1610"
HOST="localhost"
PORT=18332

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

    def connect

    end

    private
    def bitcoinRPC(method,param)
        http = Net::HTTP.new(HOST, PORT)
        request = Net::HTTP::Post.new('/')
        request.basic_auth(RPCUSER,RPCPASSWORD)
        request.content_type = 'application/json'
        request.body = {method: method, params: param, id: 'jsonrpc'}.to_json
        JSON.parse(http.request(request).body)["result"]
    end

    def openassetsRPC()
      api = OpenAssets::Api.new({
          network:           'testnet',
          rpc: {
              user:              'shu',
              password:          'ubuntu1610',
              schema:            'http',
              port:               18332,
              host:              'localhost'}
      }) 
      utxo_list = api.list_unspent
      JSON.pretty_generate(utxo_list)
    end
end
