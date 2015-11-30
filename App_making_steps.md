Steps to making a Ruby on Rails App

(I) - Getting started
      1 - Make sure that Xcode is up-to-date
      2 - on Terminal: rails new app_name
      3 - git init
      4 - git add README.md
      5 - git commit -m "first commit"
      6 - git remote add origin git@github.com:user_name/app_name.git (enter password)
      7 - git push -u origin master
(II) - User Story - sign up w/ user name, password & email (Devise)
      1 - In Gemfile: ```+ gem 'devise'```
      2 - On Terminal: bundle // rails g devise:install
      3 - In config/environments/development.rb:
             ```
      +      config.action_mailer.default_url_options = {host: 'localhost:3000'}
      +      config.action_mailer.delivery_method = :smtp
      +      config.action_mailer.perform_deliveries = true
             ```
      4 - In config/environments/production.rb:
              ```
            ...
            #http://app_name.herokuapp.com
      +     config.action_mailer.default_url_options = {host: 'app_name.herokuapp.com'}
              ```
      5 - Unrelated but make app encrypt transactions while on config/environments/production.rb:
      ```
            ...
            # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
      -     # config.force_ssl = true
      +     config.force_ssl = true
      ```
      6 - on config/initializers/devise.rb, change ```config.mailer_sender``` to reflect the email of your choice.
      7 - Create root path, in config/routes.rb: ```+ root to: => "welcome#index"```
      8 - On Terminal: rails g devise:views // rails g devise User
      9 - In db/migrate/[timestamp]_ devise_create_users.rb:
             ```
             class DeviseCreateUsers < ActiveRecord::Migration
                def change
                   create_table(:users) do |t|
      +            ## Customization
      +            t.string :name
                     ...
                   end
                end
              end
             ```
      10 - uncomment all four lines under ## Confirmable
      11 - Allow the new param "name" to be entered into the database, in app/controllers/application_controller.rb:
      ```
              class ApplicationController < ActionController::Base
                protect_from_forgery with: :exception
      +         before_action :configure_permitted_parameters, if: :devise_controller?
      +   
      +         protected
      +   
      +         def configure_permitted_parameters
      +           devise_parameter_sanitizer.for(:sign_up) << :name
      +         end
              end
      ```      
      12 - On Terminal: rake db:migrate
      13 - In app/models/user.rb: add ```:confirmable``` to list of devise "modules" (to the right of ```:validatable```)

(III) - User Story - sign up w/ user name, password & email (Heroku & sendgrid)
      1 - On Gemfile:
      ```
      -      gem 'sqlite3'

      +      group :production do
      +         gem 'pg'
      +         gem 'rails_12factor'
      +      end

      +      group :development do
      +         gem 'sqlite3'
      +      end
       ```
       OR:
       ```
      -      gem 'sqlite3'

      +      group :production do
      +         gem 'pg'
      +      end

      +      gem 'puma'
       ```
      2 - on Terminal: bundle install --without production
      3 - Create landing page (req. by Heroku), in app/controllers/applciation_controller.rb:
       ```
        class ApplicationController < ActionController::Base
          # Prevent CSRF attacks by raising an exception.
          # For APIs, you may want to use :null_session instead.
          protect_from_forgery with: :exception

      +   def hello
      +     render text: "<h1>Hello</h1><p>Welcome home</p>"
      +   end
        end
       ```
      4 - in config/routes.rb:
       ```
           YourAppName::Application.routes.draw do
      +      root "application#hello"
            ...
       ```
      5 - On Terminal: Merge remote branch to remote master // Pull remote master to local (make sure to be on local Master)
      6 - On Terminal(and on master): heroku login
      7 - On Terminal: cd app_name
      8 - On Terminal: heroku create
      9 - On Terminal: git push heroku master --app app_name
      10 - On Terminal: heroku addons:create sendgrid:starter --app app_name
      11 - On Terminal: heroku apps:info --app app_name
      12 - On Terminal: heroku open --app app_name
      13 - In case of trouble with Heroku => On Terminal: heroku logs
      14 - On Terminal: heroku config:get SENDGRID_USERNAME
      15 - On Terminal: heroku config:get SENDGRID_PASSWORD
      16 - Create config/initializers/setup_mail.rb
      17 - In config/initializers/setup_mail.rb:
      ```
      +    if Rails.env.development? || Rails.env.production?
      +       ActionMailer::Base.delivery_method = :smtp
      +       ActionMailer::Base.smtp_settings = {
      +         address:        'smtp.sendgrid.net',
      +         port:           '587',
      +         authentication: :plain,
      +         user_name:      ENV['SENDGRID_USERNAME'],
      +         password:       ENV['SENDGRID_PASSWORD'],
      +         domain:         'heroku.com',
      +         enable_starttls_auto: true
      +       }
      +     end
      ```
      18 - Add USERNAME and PASSWORD security with Figaro, in Gemfile:
      ```
      +     gem 'figaro,' '1.0'
      ```
      19 - On Terminal: bundle
      20 - Generate application.yml, on Terminal: figaro install
      21 - On config/application.yml:
      ```
      +     SENDGRID_PASSWORD: 'password'
      +     SENDGRID_USERNAME: 'username'
      ```
      22 - Check to see that /config/application.example.yml has been included in .gitignore
      23 - Show collaborators what we are hiding, on Terminal: touch config/application.example.yml and add:
      ```
      +     SENDGRID_PASSWORD:
      +     SENDGRID_USERNAME:
      ```
      24 - Update environment variables on production, on Terminal: figaro heroku:set -e production --app app_name (this app's name is: safe-hollows-5109)
      25 - Check environment variables, on Terminal: heroku config --app app_name
      26 - To remove environment variables, on Terminal: heroku config:unset VARIABLE
      27 - More security => on Terminal: rake secret // heroku config:set SECRET_KEY_BASE=thegeneratedtoken --app app_name

(V) - Making User Views
      1 - In Gemfile: ```+ gem 'bootstrap-sass'```
      2 - Rename application.css to aplication.scss
      3 - In app/assets/stylesheets/application.scss:
      ```
      + @import "bootstrap-sprockets";
      + @import "bootstrap";
      ```
      4 - In app/assets/javascripts/application.js: ```+ //= require bootstrap```
      5 - Add Bootstrap and links to app/views/layouts/application.html.erb:
      ```
            <title>Blocitoff</title>
      +     <meta name="viewport" content="width=device-width, initial-scale=1">
            <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
            <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
            <%= csrf_meta_tags %>
          </head>
          <body>
            <div class="container">
      +       <ul class="nav nav-tabs">
      -       <ul>
                <li><%= link_to "Home", welcome_index_path %></li>
                <li><%= link_to "About", welcome_about_path %></li>

      +         <div class="pull-right user-info">
      +           <%= if current_user %>
      +             Hello <%= link_to (current_user.name || current_user.email), edit_user_registration_path %>! <%= link_to "Sign out", destroy_user_session_path, method: :delete %>
      +           <% else %>
      +           <%= link_to "Sign In", new_user_session_path %> or
      +           <%= link_to "Sign Up", new_user_registration_path %>
      +           <% end %>
      +         </div>
              </ul>
            <%= yield %>
            </div>
        ```
      6 - In config/environments/development.rb:
        ```
      -     # Don't care if mailer doesn't work
      -     config.action_mailer.raise_delivery_errors = false
      +     # Override Action Mailer's 'silent errors' in development
      +     config.action_mailer.raise_delivery_errors = true
        ```
      8 - restart rails server
      9 - Sign up, check e-mail, confirm account
      10 -
(VI) - Styling and Optimizing User Views
      1 - in app/assets/stylesheets/application.scss:
      ```
            @import "bootstrap";

      +     .user-info {
      +       margin-top: 9px;
      +     }
      +
      +     .nav {
      +       margin-top: 5px;
      +     }
      ```
      2 - Switch Ruby and Bootstrap code in  app/views/devise/registrations/new.html.erb to:
      ```
            <h2>Sign up</h2>

            <div class="row">
              <div class="col-md-8">
                <%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
                  <%= devise_error_messages! %>
                  <div class="form-group">
                    <%= f.label :name %>
                    <%= f.text_field :name, autofocus: true, class: 'form-control', placeholder: "Enter name" %>
                  </div>
                  <div class="form-group">
                    <%= f.label :email %>
                    <%= f.email_field :email, class: 'form-control', placeholder: "Enter email" %>
                  </div>
                  <div class="form-group">
                    <%= f.label :password %>
                    <%= f.password_field :password, class: 'form-control', placeholder: "Enter password" %>
                  </div>
                  <div class="form-group">
                    <%= f.label :password_confirmation %>
                    <%= f.password_field :password_confirmation, class: 'form-control', placeholder: "Enter password confirmation" %>
                  </div>
                  <div class="form-group">
                    <%= f.submit "Sign up", class: 'btn btn-success' %>
                  </div>
                  <div class="form-group">
                    <%= render "devise/shared/links" %>
                  </div>
                <% end %>
              </div>
            </div>
      ```
      3 - Update html and links in welcome/index/html.erb:
      ```
      +     <br>
      +     <div class="jumbotron">
      +       <h1>Blocitoff</h1>
      +       <p>Organize with Blocitoff.</p>
      +       <p>
      +           <%= link_to "Sign In", new_user_session_path, class: 'btn +btn-primary' %> or
      +           <%= link_to "Sign Up", new_user_registration_path, class: 'btn btn-primary' %> today!
      +       </p>
      +     </div>
      +
      +     <div class="row">
      +       <div class="col-md-4">
      +         <h2>The New To-Do list, by Blocitoff</h2>
      +         <p>Create self-prioritizing, self-deleting To-Do lists.</p>
      +       </div>
      +       <div class="col-md-4">
      +         <h2>Eliminates clutter</h2>
      +         <p>Blocitoff will be the last organizer you need.</p>
      +       </div>
      +       <div class="col-md-4">
      +         <h2>Organizes your life</h2>
      +         <p>Blocitoff will make you more organized, punctual, responsible, and ethical.</p>
      +       </div>
      +     </div>
      ```
      4 - Generate users_controller to add more user functionality, on Terminal: rails g controller users show update

      5 - In app/controllers/users_controller.rb add all of the following:
      ```
            class UsersController < ApplicationController
      +       before_action :authenticate_user!, except: [:show]

              def show
              end

              def update
      +         if current_user.update_attributes(user_params)
      +           flash[:notice] = "User information updated"
      +           redirect_to edit_user_registration_path
      +         else
      +           flash[:error] = "Invalid user information"
      +           redirect_to edit_user_registration_path
      +         end
              end

      +       private

      +       def user_params
      +         params.require(:user).permit(:name)
      +       end
            end
      ```

      6 - Replace existing app/views/devise/registrations/edit.html.erb with:
      ```
            <h2>Edit <%= resource_name.to_s.humanize %></h2>

            <div class="row">
              <div class="col-md-8">
                <h3>Change email or password</h3>
                <%= form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :patch }) do |f| %>
                  <%= devise_error_messages! %>
                  <div class="form-group">
                    <%= f.label :email %>
                    <%= f.email_field :email, class: 'form-control', placeholder: "Enter email" %>
                  </div>
                  <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
                    <div class="form-group">
                      <p>Waiting confirmation for:</p>
                      <%= resource.unconfirmed_email %>
                    </div>
                  <% end %>
                  <div class="form-group">
                    <%= f.label :password %>
                    <%= f.password_field :password, class: 'form-control', placeholder: "Enter password" %>
                    <i>(leave blank if you don't want to change it)</i>
                  </div>
                  <div class="form-group">
                    <%= f.label :password_confirmation %>
                    <%= f.password_field :password_confirmation, class: 'form-control', placeholder: "Enter password confirmation" %>
                  </div>
                  <div class="form-group">
                    <%= f.password_field :current_password, class: 'form-control', placeholder: "Enter password" %>
                    <i>(we need your current password to confirm your changes)</i>
                  </div>
                  <div class="form-group">
                    <%= f.submit "Update", class: 'btn btn-success' %>
                  </div>
                <% end %>

                <h3>Edit personal information</h3>
                <%= form_for(current_user) do |f| %>
                  <div class="form-group">
                    <%= f.label :name %>
                    <%= f.text_field :name, class: 'form-control', placeholder: "Enter name", autofocus: true %>
                  </div>
                  <div class="form-group">
                    <%= f.submit "Update", class: 'btn btn-success' %>
                  </div>
                <% end %>

                <h3>Cancel my account</h3>
                <div class="form-group">
                    <p><%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: 'btn btn-danger' %></p>
                </div>
              </div>
            </div>
      ```
      7 - To make the above work, modify routes in config/routes.rb:
      ```
            devise_for :users
      +     resources :users, only: [:update]
      ```
(VII) - Creating User Profile
      1 - On Terminal: mkdir app/views/users
      2 - On Terminal: touch app/views/users/show.html.erb
      3 - Insert appropriate HTML and Ruby into app/views/users/show.html.erb
      4 - Update variables in UsersController used by users#show (specifically @user)
      5 - Add avatar functionality to user#show, on Terminal: brew update
      6 - On Terminal: brew install imagemagick (if Terminal warns that it has already been installed, then, on Terminal: brew unlink imagemagick, and install again )
      7 - In Gemfile:
      ```
      +     gem 'carrierwave'
      +     gem 'mini_magick'
      ```
      8 - On Terminal: bundle
      9 - rails generate uploader avatar
      10 - Add avatar to ```users``` table, on Terminal: rails g migration AddAvatarToUsers avatar:string
      11 - On Terminal: rake db:migration
      12 - Modify the User model, in app/models/user.rb:
      ```
            has_many :posts # for example  
      +     mount_uploader :avatar, AvatarUploader      
      ```
      13 - Modify the UsersController, in app/controllers/users_controller:
      ```
            def user_params
      -       params.require(:user).permit(:name)
      +       params.require(:user).permit(:name, :avatar)
      ```
      14 - Modify avatar_uploader, in app/uploaders/avatar_uploader.rb:
      ```
            # encoding: utf-8

            class AvatarUploader < CarrierWave::Uploader::Base

              # Include RMagick or MiniMagick support:
              # include CarrierWave::RMagick
      -       # include CarrierWave::MiniMagick
      +       include CarrierWave::MiniMagick

              # Choose what kind of storage to use for this uploader:
      -       storage :file
      -       # storage :fog
      +       storage :fog

              # Override the directory where uploaded files will be stored.
              # This is a sensible default for uploaders that are meant to be mounted:
              def store_dir
                "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
              end

              # Provide a default URL as a default if there hasn't been a file uploaded:
              # def default_url
              #   # For Rails 3.1+ asset pipeline compatibility:
              #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
              #
              #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
              # end

              # Process files as they are uploaded:
      -       # process :resize_to_fill => [200, 300]
      +       process :resize_to_fill => [200, 300]
      -       #
      -       # def scale(width, height)
      -       #   # do something
      -       # end

              # Create different versions of your uploaded files:
      -       # version :thumb do
      -       #   process :resize_to_fit => [50, 50]
      -       # end
      +       version :tiny do
      +         process resize_to_fill: [20, 20]
      +       end
      +     
      +       version :small do
      +         process resize_to_fill: [30, 30]
      +       end
      +     
      +       version :profile do
      +         process resize_to_fill: [45, 45]
      +       end

              # Add a white list of extensions which are allowed to be uploaded.
              # For images you might use something like this:
      -       # def extension_white_list
      -       #   %w(jpg jpeg gif png)
      -       # end
      +       def extension_white_list
      +         %w(jpg jpeg gif png)
      +       end

              # Override the filename of the uploaded files:
              # Avoid using model.id or version_name here, see uploader/store.rb for details.
              # def filename
              #   "something.jpg" if original_filename
              # end

            end
      ```
      15 - Using Amazon's S3 and Fog, in Gemfile: ```+ gem 'fog'```
      16 - On Terminal: bundle
      17 - touch config/initializers/fog.rb
      18 - In config/initializers/fog.rb, add the following:
       ```
            CarrierWave.configure do |config|
              config.fog_credentials = {
                provider:               'AWS',
                aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
                aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY']
              }
              config.fog_directory    = ENV['AWS_BUCKET']
              config.fog_public       = true
            end

            # Ref:
            # https://support.cloud.engineyard.com/entries/20996881-Use-CarrierWave-and-Optionally-Fog-to-Upload-and-Store-Files#update3
            # http://stackoverflow.com/questions/7946819/carrierwave-and-amazon-s3
       ```
      19 - Go to Amazon Web Services:            https://us-west-2.console.aws.amazon.com/console/home?nc2=h_m_mc&region=us-west-2#
      20 - Click on 'S3', then 'Create Bucket'
      21 - Create 'app_name-development' and 'app_name-production' (DO NOT CAPITALIZE!, NO UNDERSCORES!, NO ENDING DASHES, NO DASHES NEXT TO A PERIOD)
      22 - Click on user_name, from the drop-down list, select Security Credentials.  Transfer AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY_ID, AWS_BUCKET for development and production to application.yml:
      ```
            AWS_ACCESS_KEY_ID: your credential here
            AWS_SECRET_ACCESS_KEY: your credential here
            development:
              AWS_BUCKET: your credential here
            production:
              AWS_BUCKET: your credential here
       ```
      23 - Modify registrations#edit, on app/views/devise/registrations/edit.html.erb:
      ```
            <%= form_for(current_user) do |f| %>
              <div class="form-group">
                <%= f.label :name %>
                <%= f.text_field :name, class: 'form-control', placeholder: "Enter name", autofocus: true %>
              </div>
      +       <% if current_user.avatar? %>
      +         <div class="form-group">
      +           <p>Current avatar</p>
      +           <%= image_tag( current_user.avatar.profile.url ) %>
      +         </div>
      +       <% end %>
      +       <div class="form-group">
      +         <%= f.label :avatar %>
      +         <%= f.file_field :avatar %>
      +         <%= f.hidden_field :avatar_cache %>
      +       </div>
      +       <div class="form-group">
      +         <%= f.submit "Update", class: 'btn btn-success' %>
      +       </div>
      +     <% end %>
       ```
      24 - Modify Application layout, in app/views/layouts/application.html.erb:
      ```
            <div class="pull-right user-info">
              <% if current_user %>
      +       <%= image_tag(current_user.avatar.tiny.url) if    current_user.avatar? %>
              Hello <%= link_to (current_user.name || current_user.email), edit_user_registration_path %>! <%= link_to "Sign out", destroy_user_session_path, method: :delete %>
      ```
      25 - Modify ApplicationController so as to have app redirect to a specific page after successful Sign In, in app/controllers/application_controller.rb:
      ```
      +     def after_sign_in_path_for(resource)
      +       @user
      +     end

      ```
      26 - Modify ApplicationController so as to have app redirect to root page after successful Sign Out, in app/controllers/application_controller.rb:
      ```
      +     def after_sign_out_path_for(resource_or_scope)
      +       root_path
      +     end

      ```
      27 - Modify Application layout to create link to User profile (i.e. <% if current_user %><%= link_to (current_user.name || current_user.email)+"'s profile", @user %><% end %>)
      28 - Go through Heroku-preparation steps to optimize app for production, on Terminal: figaro heroku:set -e production
      29 - On Terminal: git push heroku master (make sure you are on master)
      30 - On Terminal: heroku run rake db:migrate
      31 - On Terminal: heroku restart

(VIII) - Creating User-paraphernalia (To-do lists, posts, etc.)
      1 - Create model, on Terminal: rails g model Item name:string user:references
      2 - Associate Users and Items in their models (has_many :items, belongs_to :user)
      3 - Create Items_controller, on Terminal: rails g controller Items create
      4 - In config/routes.rb, nest item resources underneath user resources:
      ```
      -     resources :users, only: [:update, :show]
      +     resources :users, only: [:update, :show] do
      +       resources :items, only: [:create, :destroy]
      +     end
      ```
      5 - Stub out create and destroy actions in ItemsController and include javascript rendition methods:
      ```
      class ItemsController < ApplicationController

        def destroy
          @user = User.find(params[:user_id])
          @item = @user.items.find(params[:id])

          if @item.destroy
            flash[:notice] = "The item was obliterated!"
          else
            flash[:notice] = "Oops!, the item could not be deleted.  Try again!"
          end

        respond_to do |format|
          format.html
          format.js
        end
      end

        def create
          @user = User.find(params[:user_id])
          @items = @user.items

          @item = Item.new(item_params)
          @item.user = current_user
          @new_item = Item.new

          if @item.save
            flash[:notice] = "Success! Item was saved!"
          else
            flash[:error] = "Oops! Something went wrong. The item was not saved. Please try again!"
          end

          respond_to do |format|
            format.html
            format.js
          end
        end

        private

        def item_params
          params.require(:item).permit(:name)
        end

      end
      ```
      6 - Allow items to be displayed in User#show by instantiating item in User controller:
      ```
            def show
                @user = User.find(params[:id])
      +         @items = @user.items
            end
      ```
      7 - Create item partial for entering items, on Terminal: touch app/views/items/_ form.html.erb.
      8 - in app/views/items/_ form.html.erb, add the following:
      ```
      <div class="js-items">
      <% if current_user %>
        <%= form_for [@user, Item.new], remote: true do |f| %>
          <%= f.text_field :name, placeholder: "Enter item to be done" %>
          <%= f.submit "Save item", class: 'btn btn-success' %>
        <% end %>
      <% end %>
      </div>
      ```
      9 - Create item partial for displaying items, on Terminal: touch app/views/items/_ item.html.erb.
      10 - in app/views/items/_ item.html.erb, add the following:
      ```
      <%= content_tag :div, class: 'media', id: "item-#{item.id}" do %>
      <small><%= item.name %> (created <%= time_ago_in_words(item.created_at) %> ago) | <%= link_to "Delete", [item.user, item], method: :delete, remote: true %></small>
      <% end %>

      ```
      11 - Add render syntax for the _ form and _ item partials (and items.count) in user#show:
      ```
            <div class="media-body">
              <h2 class="media-heading"><%= @user.name %>'s to do list:</h2>
      +       <div class='js-items-count'>
      +         <%= pluralize(@user.items.count, 'item')%> to complete:
      +       </div>
      +       <small>
      +         <ul>
      +           <li class="js-items">
      +             <%= render partial: 'items/item', collection: @items %>
      +           </li>
      +         </ul>
      +       <div class="new-item">
      +         <%= render partial: 'items/form', locals: {item: @item, comment: @user.items.new}%>
      +       </div>
      +       </small>
      +     </div>
      +   </div>
      + </div>
      +</div>
      ```
      12 - Create javascript helpers to 'Ajaxify' the creation and destuction of items, touch 'create.js.erb' and 'destroy.js.erb' files within app/views/items.
      13 - In app/views/items/create.js.erb add:
      ```
      <% if @item.valid? %>
      $('.js-items').append("<%= escape_javascript(render(@item)) %>");
      $('.new-item').html("<%= escape_javascript(render partial: 'items/form', locals: {user: @user, item: @new_item}) %>");
      $('.js-items-count').html("<%= pluralize(@item.user.items.count, 'item') %> to complete:");
      <% else %>
      $('.new-item').html("<%= escape_javascript(render partial: 'items/form', locals: {user: @user, item: @item}) %>");
      <% end %>
      ```
      14 - In app/views/items/destroy.js.erb add:
      ```
      <% if @item.destroyed? %>
      $('#item-' +<%= @item.id %>).fadeOut('slow');
      $('.js-items-count').html("<%= pluralize(@item.user.items.count, 'item') %> to complete:");
      <% else %>
      $('#item-' +<%= @item.id %>).prepend("<div class='alert-danger'><%= flash[:error] %></div>");
      <% end %>
      ```
      15 - Make sure to update migrations, on Terminal: rake db:migrate
(IX) - Seeding data
      1 - In Gemfile: ```+ gem 'faker'```
      2 - On Terminal: bundle
      3 - In db/seeds.rb:
      ```
      ```




- Testing User sign_up, sign_in, sign_out
      1 - In Gemfile:
      ```
            group :development, :test do
              # Call 'byebug' anywhere in the code to stop execution and get a debugger console
              gem 'byebug'
      +       gem 'rspec-rails', '~> 3.0'
            end
      ```
      2 - On Terminal: Bundle
      3 - On Terminal: rails g rspec:install
      4 - Set up a separate test database, on Terminal: rake db:test:prepare (Warning: according to Bloc, this command has been deprecated in the newest versions of Rails)
      5 - Create TestFactories module, on Terminal: mkdir spec/support
      6 - On Terminal: touch spec/support/test_factories.rb
      7 - In spec/support/test_factories.rb, add the following:
      ```
            module TestFactories

              def associated_post(options={})
                post_options = {
                  title:  'Post title',
                  body:   'Post bodies must be pretty long.',
                  topic:  Topic.create(name: 'Topic name'),
                  user:   authenticated_user
                }.merge(options)
                Post.create(post_options)
              end

              def authenticated_user(options={})
                user_options = {email: "email#{rand}@fake.com", password: 'password'}.merge(options)
                user = User.new(user_options)
                user.skip_confirmation!
                user.save
                user
              end
            end

      ```
      8 - Make The above file 'requireable', in spec/support/test_factories.rb:
      ```
      -     # Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
      +     Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
      ```
      9 - In Gemfile: ```+ gem 'capybara'```
      10 - On Terminal: bundle
      11 - Makes sure to have something in app/views/users/show.html.erb
      12 - References in show.html.erb to @user should be backed up in UsersController:
      ```
            def show
      +       @user = User.find(params[:id])
            end
      ```
      13 -



      - Install FactoryGirl.  On Gemfile: ```+ gem 'factory_girl_rails'
      , '~> 4.0'```
      - On Terminal: bundle
      - Make FactoryGirl available in specs.  In spec/rails_helper.rb:
      ```
      +     # Make Factory Girl's methods available
      +     config.include FactoryGirl::Syntax::Methods
      ```
      - On Terminal: mkdir spec/factories
      - On Terminal: touch spec/factories/user.rb
      - In spec/factories/user.rb, add all of the following:
      ```
            FactoryGirl.define do
              factory :user do
                name "Douglas Adams"
                sequence(:email, 100) { |n| "person#{n}@example.com" }
                password "helloworld"
                password_confirmation "helloworld"
                confirmed_at Time.now
              end
            end
      ```
      - On Terminal: mkdir spec/features
      - On Terminal: touch spec/features/profiles_spec.rb
      ```


      - For Spec'cing profiles, lookt at Checkpoint 54 "TDDing the Resource Basics", in spec/features/profiles_spec.rb, add the following:
      ```
            require 'rails_helper'

            describe "Visiting profiles" do

              include TestFactories

              before do
                @user = authenticated_user
              end

              describe "not signed in" do

                it "shows profile" do
                  visit user_path(@user)
                  expect(current_path).to eq(user_path(@user))
                end

              end
            end
      ```
