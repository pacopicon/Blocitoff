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
      4 - Create roote path, in config/routes.rb: ```+ root to: => "welcome#index"```
      5 - On Terminal: rails g devise:views // rails g devise User
      7 - In db/migrate/[timestamp]_ devise_create_users.rb:
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
      8 - uncomment all four lines under ## Confirmable
      9 - Allow the new param "name" to be entered into the database, in app/controllers/application_controller.rb:
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
      9 - On Terminal: rake db:migrate
      10 - In app/models/user.rb: add ```:confirmable``` to list of devise "modules" (to the right of ```:validatable```)

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
      +    if Rails.env.development?
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
      +             Hello <%= current_user.email %>! <%= link_to "Sign out", destroy_user_session_path, method: :delete %>
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
(VI) - Styling User Views
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
(VII) - Testing User sign_up, sign_in, sign_out
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
