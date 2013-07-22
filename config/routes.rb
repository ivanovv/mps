MpSearch2::Application.routes.draw do
  get 'articles/:q', :to => 'articles#index', :as => 'articles'
end
