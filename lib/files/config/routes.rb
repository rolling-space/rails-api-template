# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs' # rat-rswag
  mount Rswag::Api::Engine => '/api-docs' # rat-rswag
end
