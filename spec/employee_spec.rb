require 'spec_helper'

RSpec.describe Employee do
  describe 'validations' do
    it 'is valid with all required fields' do
      employee = Employee.new(full_name: 'Alice Smith', job_title: 'Engineer',
                              country: 'India', salary: 80_000)
      expect(employee.valid?).to be true
    end

    it 'is invalid without a full_name' do
      employee = Employee.new(job_title: 'Engineer', country: 'India', salary: 80_000)
      expect(employee.valid?).to be false
      expect(employee.errors).to include('full_name is required')
    end

    it 'is invalid without a job_title' do
      employee = Employee.new(full_name: 'Alice Smith', country: 'India', salary: 80_000)
      expect(employee.valid?).to be false
      expect(employee.errors).to include('job_title is required')
    end

    it 'is invalid without a country' do
      employee = Employee.new(full_name: 'Alice Smith', job_title: 'Engineer', salary: 80_000)
      expect(employee.valid?).to be false
      expect(employee.errors).to include('country is required')
    end

    it 'is invalid without a salary' do
      employee = Employee.new(full_name: 'Alice Smith', job_title: 'Engineer', country: 'India')
      expect(employee.valid?).to be false
      expect(employee.errors).to include('salary is required')
    end

    it 'is invalid when salary is zero or negative' do
      employee = Employee.new(full_name: 'Alice Smith', job_title: 'Engineer',
                              country: 'India', salary: 0)
      expect(employee.valid?).to be false
      expect(employee.errors).to include('salary must be positive')
    end
  end
end
