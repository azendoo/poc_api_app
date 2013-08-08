# encoding: UTF-8
require 'spec_helper'

describe Api::V1::UsersController do
  describe 'routing' do

    it 'routes to #index' do
      get('/users').should route_to('users#index')
    end

    it 'routes to #show' do
      get('/users/1').should route_to('users#show', id: '1')
    end

    it 'routes to #update' do
      put('/users/1').should route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/users/1').should route_to('users#destroy', id: '1')
    end

  end
end
