# encoding: UTF-8
# XXX :
# Required to add StrongParameters support to Mongoid.
Mongoid::Document.send(:include, ActiveModel::ForbiddenAttributesProtection)
ActionController::API.send :include, ActionController::StrongParameters
