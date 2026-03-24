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

	describe '.create' do
    it 'persists a valid employee to the database' do
      result = Employee.create(full_name: 'Alice Smith', job_title: 'Engineer',
                               country: 'India', salary: 80_000)
      expect(result[:success]).to be true
      expect(result[:employee].id).not_to be_nil
    end

    it 'returns errors for an invalid employee' do
      result = Employee.create(job_title: 'Engineer', country: 'India', salary: 80_000)
      expect(result[:success]).to be false
      expect(result[:errors]).to include('full_name is required')
    end
  end

  describe '.find' do
    it 'returns the employee by id' do
      created = Employee.create(full_name: 'Bob Jones', job_title: 'Designer',
                                country: 'United States', salary: 90_000)
      found = Employee.find(created[:employee].id)
      expect(found.full_name).to eq('Bob Jones')
    end

    it 'returns nil when employee does not exist' do
      expect(Employee.find(999)).to be_nil
    end
  end
end
