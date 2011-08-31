Snote::Application.routes.draw do
  devise_for :users, :path => '', :path_names => { :sign_in => 'login', :sign_out => 'logout'}

  root :to => "notes#index"
  resources :notes do
    collection do
      get :export
    end
  end
  match 'notes/example' => "notes#example"
  match 'notes/search' => "notes#search"
  match 'notes/share/:id' => "notes#share", :as => 'note_share'
  match "public/notes/:user/:note_id" => "notes#show"
  match "u/:user/:note_id" => "notes#show", :as => 'post_note'

end

