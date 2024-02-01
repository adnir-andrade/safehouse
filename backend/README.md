# README

# The Safehouse - API

The Safehouse API is a single-version API developed using Ruby on Rails, using RSpec for automated testing and PostgreSQL as its database.

## Key Features:

#### Core Functionalities:

- ##### PDF Report Generation:
  Generate PDF reports with dynamic sorting capabilities;
- ##### Entities Creation and Management:
  Create and manage survivors, locations and items, keeping track of their informations;
- ##### Denounce System:
  The "Denounce System" is used to flag survivors as infected. After receiving 5 or more reports, a survivor is marked as "infected", being considered as dead and being banned from trades and excluded from the majority of reports;
- ##### Trading System:
  A simple, but consistent, trading system that supports item-for-item, item-for-cash, or mixed transactions (think of a Fallout-like trading system);

## Getting Started

### Prerequisites

- Ruby (~> 3.2.2)
- Rails (~> 7.1.2)
- PostgreSQL (~> 1.1):
  This project uses PostgreSQL gem for connecting to the database, so you don't _really_ need to have it installed;

### Dependencies

The dependencies bellow are included in the gemfile and will be automatically installed using `bundle install`

- Active Model Serializers (~> 0.10.0):
  For customizing JSON serialization.
- Rack CORS:
  Handles Cross-Origin Resource Sharing (CORS), enabling cross-origin Ajax.
- Prawn (~> 2.4):
  A PDF generation library.
- Prawn-Table (~> 0.2.2):
  Adds table support to the Prawn PDF generation library.
- Matrix (~> 0.4.2):
  Used for matrix operations.
- Pry (development, test):
  A powerful alternative to the standard IRB console.
- Bullet (development, test):
  Helps in detecting and optimizing N+1 query issues.
- RSpec-Rails (development, test):
  A testing framework for Rails applications.
- Faker (development, test):
  Generates fake data for testing purposes.
- Factory Bot Rails (development, test):
  A library for setting up Ruby objects as test data.

### Installation

1. Clone the repository
   ```bash
   https://github.com/adnir-andrade/safehouse.git
   ```
2. Navigate to the backend directory
3. Install dependencies
   ```bash
   bundle install
   ```
4. Set up the database with Docker Compose:
   _I didn't change the DB user and password in the docker-compose.yml and database.yml. I've left those solely for being used here by anyone. So you don't need to configure anything._
   ```bash
   docker-compose up
   ```
5. Migrate and seed
   ```bash
   rails db:create db:migrate
   RAILS_ENV=test rails db:migrate
   rails db:seed
   ```
6. Use it!
   You can test if everything is alright by starting the project using `rails s` or executing its tests with `bundle exec rspec`
