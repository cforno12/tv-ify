Rails.application.routes.draw do
  root 'welcome#index'

  get '/button', to: 'scrapper#run', as: 'scrap'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
