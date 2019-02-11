Rails.application.routes.draw do
  get '/', to: "games#new"
  post 'score', to: "games#score"
end
