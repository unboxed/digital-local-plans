# frozen_string_literal: true

DlpAdmin::Engine.routes.draw do
  get "/", to: ->(env) { [200, {}, ["hello world"]] }
end
