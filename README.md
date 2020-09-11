Movie Night App
===============



## Overview

Movie Night App is a CLI application that helps a user select a movie from a vast library of top films based on their personal genre and runtime preferences. Your movie night just got a lot simpler.

## Installation

Fork and clone the repository from [github](https://github.com/noaheakin/ruby-project-alt-guidelines-sea01-seng-ft-082420
) to install Movie Night App.

Once forked and cloned to local machine use the package manager [bundler](https://bundler.io/) to install any necessary gems to run the program.
After bundle install is complete, run 'rake db:seed' in the terminal to populate the movie database.

```bash
bundle install
rake db:seed
```

## Usage

Run the following command from the project directory in your terminal to get started.

```ruby
 ruby bin/run.rb
```

Follow prompts to create then select user. You will then be prompted for a desired genre and movie runtime, which will help curate a list of qualifying movies from the database. Users are able to manually pick a movie from the list or have the app randomly choose for them. 

If a user already exists, that user can be selected to go through the previously described prompts to arrive at a movie selection. Additionally, an existing user can be accessed to change their username, delete their account or view their watch history. 
