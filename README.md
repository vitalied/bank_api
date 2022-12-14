### Objective

Your assignment is to build an internal API for a fake financial institution using Ruby and Rails.

### Brief

While modern banks have evolved to serve a plethora of functions, at their core, banks must provide certain basic features. Today, your task is to build the basic HTTP API for one of those banks! Imagine you are designing a backend API for bank employees. It could ultimately be consumed by multiple frontends (web, iOS, Android etc).

### Tasks

- Implement assignment using:
  - Language: **Ruby**
  - Framework: **Rails**
- There should be API routes that allow them to:
  - Create a new bank account for a customer, with an initial deposit amount. A
    single customer may have multiple bank accounts.
  - Transfer amounts between any two accounts, including those owned by
    different customers.
  - Retrieve balances for a given account.
  - Retrieve transfer history for a given account.
- Write tests for your business logic

Feel free to pre-populate your customers with the following:

```json
[
  {
    "id": 1,
    "name": "Arisha Barron"
  },
  {
    "id": 2,
    "name": "Branden Gibson"
  },
  {
    "id": 3,
    "name": "Rhonda Church"
  },
  {
    "id": 4,
    "name": "Georgina Hazel"
  }
]
```

You are expected to design any other required models and routes for your API.

### Evaluation Criteria

- **Ruby** best practices
- Completeness: did you complete the features?
- Correctness: does the functionality act in sensible, thought-out ways?
- Maintainability: is it written in a clean, maintainable way?
- Testing: is the system adequately tested?
- Documentation: is the API well-documented?

### CodeSubmit

Please organize, design, test and document your code as if it were going into production - then push your changes to the master branch. After you have pushed your code, you may submit the assignment on the assignment page.

All the best and happy coding,

The Bloom Team


# Bank API

## Setup

### Build app image
```
docker compose build
```

### Install gems
```
docker compose run bank_api bundle install
```

### Database
#### Run postgresql
```
docker compose up -d postgres
```

#### Prepare DB
##### Create database, run migrations and add seed entries.
```
docker compose run bank_api bundle exec rails db:setup
```

## Run app
```
docker compose up
```

## Run tests
```
docker compose run bank_api bundle exec rspec
```

## Access app

#### URL
http://localhost:3000

#### Headers
API endpoints are protected by HTTP Token Authentication
```
Authorization: Token access_token_hash
Accept: application/json
Content-Type: application/json
```
#### Body
```
{
}
```

## Access API docs

#### URL
http://localhost:8080

## Insomnia Request Collection

Request Collection for [Insomnia REST API Client](https://insomnia.rest/download):
[insomnia.json](insomnia.json)
