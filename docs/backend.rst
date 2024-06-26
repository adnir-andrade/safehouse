The Safehouse - API
===================

API Documentation
------------------

You can find the API documentation `here <https://haotran.notion.site/Safehouse-API-690c17e6654d4b99b2ccbc9fe0e73f71?pvs=4>`_.

The Safehouse API is a single-version API developed using Ruby on  Rails, using RSpec for automated testing, and PostgreSQL as the database.

-----------------

Key Features
-----------------

PDF Report Generation
~~~~~~~~~~~~~~~~~~~~~

Generate PDF reports with dynamic sorting capabilities.

Entities Creation and Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create and manage survivors, locations, and items, keeping track of their information.

Denounce System
~~~~~~~~~~~~~~~~

The “Denounce System” is used to flag survivors as infected. After receiving 5 or more reports, a survivor is marked as “infected”,  considered dead, banned from trades, and excluded from most of the reports.

Trading System
~~~~~~~~~~~~~~~~

A simple but consistent trading system that supports item-for-item, item-for-cash, or mixed transactions (think of a Fallout-like trading system).

-----------------

Getting Started
-----------------

Prerequisites
~~~~~~~~~~~~~~~~

- Ruby (~> 3.2.2)
- Rails (~> 7.1.2)
- PostgreSQL (~> 1.1)

This project uses the PostgreSQL gem for connecting to the database. If you don't have PostgreSQL installed, you can install the gem using `gem install pg`.

Dependencies
~~~~~~~~~~~~~~~~

The dependencies below are included in the `Gemfile` and will be automatically installed using `bundle install`.

- Active Model Serializers (~> 0.10.0): For customizing JSON serialization.
- Rack CORS: Handles Cross-Origin Resource Sharing (CORS), enabling cross-origin Ajax.
- Prawn (~> 2.4): A PDF generation library.
- Prawn-Table (~> 0.2.2): Adds table support to the Prawn PDF generation library.
- Matrix (~> 0.4.2): Used for matrix operations.
- Pry (development, test): A powerful alternative to the standard IRB console.
- Bullet (development, test): Helps in detecting and optimizing N+1 query issues.
- RSpec-Rails (development, test): A testing framework for Rails applications.
- Faker (development, test): Generates fake data for testing purposes.
- Factory Bot Rails (development, test): A library for setting up Ruby objects as test data.

Installation
-----------------

1. Clone the repository:

.. code-block:: console

   git clone https://github.com/adnir-andrade/safehouse.git

2. Navigate to the backend directory.
   
3. Install dependencies:
   
.. code-block:: console

    bundle install

4. Set up the database with Docker Compose:
   
.. code-block:: console

    docker compose up

.. note::
    *The DB user and password in `docker-compose.yml` and `database.yml` are left as default for ease of use.*

1. Migrate and seed the database:
   
.. code-block:: console

    rails db:create db:migrate
    RAILS_ENV=test rails db:migrate
    rails db:seed

6. Use it!

-----------------

Test if everything is set up correctly by starting the project using `rails s -b 0.0.0.0` or executing its tests with `bundle exec rspec`.