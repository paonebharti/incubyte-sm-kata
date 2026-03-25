# Incubyte Salary Management Kata

A production-ready Ruby API built with strict Test-Driven Development (TDD), implementing employee management, salary calculation, and salary metrics.

## Tech Stack

- **Language:** Ruby 3.2
- **Web Framework:** Sinatra
- **Database:** SQLite via Sequel ORM
- **Testing:** RSpec + Rack::Test

## Getting Started

### Prerequisites

- Ruby 3.2+
- Bundler

### Setup

```bash
git clone https://github.com/paonebharti/incubyte-sm-kata
cd incubyte-sm-kata
bundle install
```

### Run Tests

```bash
bundle exec rspec
```

Tests run against an in-memory SQLite database — no setup needed.

### Run the Server

```bash
bundle exec rackup config.ru
# Server starts at http://localhost:9292
```

---

## API Endpoints

### Employee CRUD

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/employees` | Create a new employee |
| GET | `/employees` | List all employees |
| GET | `/employees/:id` | Get a specific employee |
| PATCH | `/employees/:id` | Update an employee |
| DELETE | `/employees/:id` | Delete an employee |

**Employee fields:**
```json
{
  "full_name": "Alice Smith",
  "job_title": "Software Engineer",
  "country": "India",
  "salary": 80000
}
```

### Salary Calculation

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/employees/:id/salary` | Calculate net salary with deductions |

**Deduction Rules:**
- India: 10% TDS
- United States: 12% TDS
- All other countries: No deduction

**Example response:**
```json
{
  "employee_id": 1,
  "gross_salary": 100000.0,
  "tds": 10000.0,
  "net_salary": 90000.0,
  "country": "India"
}
```

### Salary Metrics

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/salary-metrics/country?country=India` | Min, max, avg salary by country |
| GET | `/salary-metrics/job-title?job_title=Engineer` | Average salary by job title |

**Example response (by country):**
```json
{
  "country": "India",
  "minimum": 60000.0,
  "maximum": 100000.0,
  "average": 80000.0
}
```

---

## TDD Approach

This project was built following a strict Red → Green → Refactor cycle. Each commit in the history represents one step in that cycle:

1. Write a failing test (Red)
2. Write the minimum code to pass it (Green)
3. Refactor for clarity and design (Refactor)

The commit history is intentional and tells the full story of how the code evolved.

---

## Implementation Details

### AI Usage

This project was developed with the assistance of **Claude (Anthropic)** as a pair-programming tool. Here's how AI was used:

- **Scaffolding:** Initial project structure (Gemfile, directory layout, Sinatra boilerplate) was scaffolded with AI assistance.
- **Test case generation:** AI helped identify edge cases (missing params, empty countries, single-employee metrics).
- **Code review:** AI reviewed class design and suggested extracting `SalaryCalculator` and `SalaryMetrics` as separate classes from the `Employee` model.
- **README drafting:** This README was drafted with AI assistance.

All code was reviewed, understood, and intentionally committed by the developer. AI was used as a tool, not a replacement for understanding.

### Design Decisions

- **Plain Ruby, no Rails:** The kata doesn't require a full framework. Sinatra keeps things lightweight and focused.
- **Sequel over ActiveRecord:** Sequel works naturally without Rails and gives explicit control over queries.
- **In-memory SQLite for tests:** Fast, isolated, zero-setup test runs.
- **Separate Calculator and Metrics classes:** Single Responsibility Principle — the `Employee` model handles identity and persistence; calculation and metrics logic live in their own classes.
