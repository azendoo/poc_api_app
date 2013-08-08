# encoding: UTF-8
require 'spec_helper'

describe Api::V1::TokensController do
  describe 'routing' do

    it 'routes to #create' do
      post('/login').should route_to('tokens#create')
    end

    it 'routes to #destroy' do
      delete('/logout').should route_to('tokens#destroy')
    end

  end
end
