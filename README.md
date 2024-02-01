# The Safehouse

Safehouse is a work-in-progress (WIP) application designed to test and showcase my skills with Ruby on Rails for backend development and ReactJS + Tailwind for frontend.
This monoproject, as of right now, consists of two projects:

## Backend (The Safehouse - API):

### [API Get Started](https://github.com/adnir-andrade/safehouse/tree/main/backend)

- A single-version API built on Ruby on Rails;
- RSpec for automatizing tests;
- Postgresql for database (using Rails's Docker Compose);
- Generation of PDF reports with customizable sorting;
- With this API, you currently can:
  - Register and manage survivors;
  - Register and manage locations;
  - Register and manage items and prices;
  - A "denounce system" to flag survivors as infected;
  - A trading system capable of trading items for other items, items for cash, or a mix of both;
  - More info in the sub-repository README

## Frontend (WIP):

- It will consist of a web app where to implement the API described above, built on React and stylized with Tailwind;
- As a survivor, you'll have your account to manage your inventory, buy resources, update your location, and report people as infected;
- As a manager, you'll be able to manage your survivors, oversee the local shop (inventory, prices, availability), and configure your outpost settings;

_All of this is a work in progress for study and showcase purposes, and there is no plan to publish this in any way._
