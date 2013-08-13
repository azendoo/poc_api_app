# encoding: UTF-8
require 'spec_helper'

describe Api::V1::RegistrationsController do
  describe 'routing' do

    it 'routes to #create' do
      post('/users').should route_to('registrations#create')
    end

  end
end
