Rails.application.routes.draw do
  constraints format: 'json' do
    resources :projects
  end
end
