require 'spec_helper'

RSpec.describe 'Salary API' do
  def json_body
    JSON.parse(last_response.body, symbolize_names: true)
  end

  def create_employee(attrs = {})
    defaults = { full_name: 'Alice Smith', job_title: 'Engineer',
                 country: 'India', salary: 80_000 }
    post '/employees', defaults.merge(attrs).to_json
    json_body
  end

  describe 'POST /employees' do
    it 'creates an employee and returns 201' do
      post '/employees', { full_name: 'Alice Smith', job_title: 'Engineer',
                           country: 'India', salary: 80_000 }.to_json
      expect(last_response.status).to eq(201)
      expect(json_body[:full_name]).to eq('Alice Smith')
      expect(json_body[:id]).not_to be_nil
    end

    it 'returns 422 when required fields are missing' do
      post '/employees', { job_title: 'Engineer' }.to_json
      expect(last_response.status).to eq(422)
      expect(json_body[:errors]).not_to be_empty
    end
  end

  describe 'GET /employees' do
    it 'returns all employees as an array' do
      create_employee(full_name: 'Alice Smith')
      create_employee(full_name: 'Bob Jones', country: 'United States')
      get '/employees'
      expect(last_response.status).to eq(200)
      expect(json_body.size).to eq(2)
    end
  end

  describe 'GET /employees/:id' do
    it 'returns the employee for a valid id' do
      employee = create_employee
      get "/employees/#{employee[:id]}"
      expect(last_response.status).to eq(200)
      expect(json_body[:full_name]).to eq('Alice Smith')
    end

    it 'returns 404 for an unknown id' do
      get '/employees/999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'PATCH /employees/:id' do
    it 'updates an employee field' do
      employee = create_employee
      patch "/employees/#{employee[:id]}", { salary: 95_000 }.to_json
      expect(last_response.status).to eq(200)
      expect(json_body[:salary]).to eq(95_000)
    end

    it 'returns 422 when update results in invalid state' do
      employee = create_employee
      patch "/employees/#{employee[:id]}", { salary: -1 }.to_json
      expect(last_response.status).to eq(422)
    end
  end

  describe 'DELETE /employees/:id' do
    it 'deletes an employee and returns 204' do
      employee = create_employee
      delete "/employees/#{employee[:id]}"
      expect(last_response.status).to eq(204)
    end

    it 'returns 404 when deleting a non-existent employee' do
      delete '/employees/999'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /employees/:id/salary' do
    it 'returns salary breakdown for India (10% TDS)' do
      employee = create_employee(country: 'India', salary: 100_000)
      get "/employees/#{employee[:id]}/salary"
      expect(last_response.status).to eq(200)
      expect(json_body[:tds]).to eq(10_000.0)
      expect(json_body[:net_salary]).to eq(90_000.0)
    end

    it 'returns salary breakdown for United States (12% TDS)' do
      employee = create_employee(country: 'United States', salary: 100_000)
      get "/employees/#{employee[:id]}/salary"
      expect(json_body[:tds]).to eq(12_000.0)
      expect(json_body[:net_salary]).to eq(88_000.0)
    end

    it 'returns no deduction for other countries' do
      employee = create_employee(country: 'Germany', salary: 100_000)
      get "/employees/#{employee[:id]}/salary"
      expect(json_body[:tds]).to eq(0.0)
      expect(json_body[:net_salary]).to eq(100_000.0)
    end

    it 'returns 404 for unknown employee' do
      get '/employees/999/salary'
      expect(last_response.status).to eq(404)
    end
  end

  describe 'GET /salary-metrics/country' do
    before(:each) do
      create_employee(full_name: 'Priya Sharma',  job_title: 'Engineer', country: 'India',         salary: 60_000)
      create_employee(full_name: 'Rahul Gupta',   job_title: 'Engineer', country: 'India',         salary: 80_000)
      create_employee(full_name: 'Anjali Singh',  job_title: 'Manager',  country: 'India',         salary: 100_000)
      create_employee(full_name: 'John Doe',      job_title: 'Manager',  country: 'United States', salary: 120_000)
    end

    it 'returns min, max, average salary for a country' do
      get '/salary-metrics/country?country=India'
      expect(last_response.status).to eq(200)
      expect(json_body[:minimum]).to eq(60_000.0)
      expect(json_body[:maximum]).to eq(100_000.0)
      expect(json_body[:average]).to eq(80_000.0)
    end

    it 'returns 404 when no employees in given country' do
      get '/salary-metrics/country?country=Antarctica'
      expect(last_response.status).to eq(404)
    end

    it 'returns 400 when country param is missing' do
      get '/salary-metrics/country'
      expect(last_response.status).to eq(400)
    end
  end

  describe 'GET /salary-metrics/job-title' do
    before(:each) do
      create_employee(full_name: 'Priya Sharma', job_title: 'Engineer', country: 'India',         salary: 60_000)
      create_employee(full_name: 'Rahul Gupta',  job_title: 'Engineer', country: 'India',         salary: 80_000)
      create_employee(full_name: 'John Doe',     job_title: 'Manager',  country: 'United States', salary: 120_000)
    end

    it 'returns average salary for a job title' do
      get '/salary-metrics/job-title?job_title=Engineer'
      expect(last_response.status).to eq(200)
      expect(json_body[:average]).to eq(70_000.0)
    end

    it 'returns 404 when no employees have the given job title' do
      get '/salary-metrics/job-title?job_title=Astronaut'
      expect(last_response.status).to eq(404)
    end

    it 'returns 400 when job_title param is missing' do
      get '/salary-metrics/job-title'
      expect(last_response.status).to eq(400)
    end
  end
end
