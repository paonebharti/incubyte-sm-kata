require 'sinatra/base'
require 'sinatra/json'
require 'json'
require_relative 'lib/database'
require_relative 'lib/employee'
require_relative 'lib/salary_calculator'
require_relative 'lib/salary_metrics'

class SalaryApp < Sinatra::Base
  set :show_exceptions, false

  before do
    content_type :json
    if request.body.size > 0
      body = request.body.read
      @params_json = body.empty? ? {} : JSON.parse(body, symbolize_names: true)
    else
      @params_json = {}
    end
  end

  # ── Employee CRUD ──────────────────────────────────────────────

  post '/employees' do
    result = Employee.create(@params_json)
    if result[:success]
      status 201
      result[:employee].to_h.to_json
    else
      status 422
      { errors: result[:errors] }.to_json
    end
  end

  get '/employees' do
    Employee.all.map(&:to_h).to_json
  end

  get '/employees/:id' do
    employee = Employee.find(params[:id].to_i)
    if employee
      employee.to_h.to_json
    else
      status 404
      { error: 'Employee not found' }.to_json
    end
  end

  patch '/employees/:id' do
    result = Employee.update(params[:id].to_i, @params_json)
    if result[:success]
      result[:employee].to_h.to_json
    else
      status 422
      { errors: result[:errors] }.to_json
    end
  end

  delete '/employees/:id' do
    result = Employee.delete(params[:id].to_i)
    if result[:success]
      status 204
    else
      status 404
      { error: result[:errors].first }.to_json
    end
  end

  # ── Salary Calculation ─────────────────────────────────────────

  get '/employees/:id/salary' do
    employee = Employee.find(params[:id].to_i)
    if employee
      SalaryCalculator.calculate(employee).to_json
    else
      status 404
      { error: 'Employee not found' }.to_json
    end
  end

  # ── Salary Metrics ─────────────────────────────────────────────

  get '/salary-metrics/country' do
    country = params[:country]
    if country.nil? || country.strip.empty?
      status 400
      return { error: 'country parameter is required' }.to_json
    end

    result = SalaryMetrics.by_country(country)
    if result
      result.to_json
    else
      status 404
      { error: "No employees found for country: #{country}" }.to_json
    end
  end

  get '/salary-metrics/job-title' do
    job_title = params[:job_title]
    if job_title.nil? || job_title.strip.empty?
      status 400
      return { error: 'job_title parameter is required' }.to_json
    end

    result = SalaryMetrics.by_job_title(job_title)
    if result
      result.to_json
    else
      status 404
      { error: "No employees found for job title: #{job_title}" }.to_json
    end
  end

  run! if app_file == $0
end
