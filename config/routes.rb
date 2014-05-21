Rails.application.routes.draw do
  constraints format: 'json' do
    resources :accounts do
      resources :projects
    end
    resources :projects do
      resources :discussions
    end
    resources :discussions do
      resources :comments, defaults: { parent_type: "discussion" }
    end
    resources :people
  end

  post "/authenticate/:token" => "authentications#create"
  get  "/authenticate/:token" => "authentications#create"
  root to: "homepages#show"
end
