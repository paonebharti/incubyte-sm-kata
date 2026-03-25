require 'spec_helper'

RSpec.describe SalaryCalculator do
  let(:india_employee) do
    result = Employee.create(full_name: 'Priya Sharma', job_title: 'Engineer',
                             country: 'India', salary: 100_000)
    result[:employee]
  end

  let(:us_employee) do
    result = Employee.create(full_name: 'John Doe', job_title: 'Manager',
                             country: 'United States', salary: 100_000)
    result[:employee]
  end

  let(:other_employee) do
    result = Employee.create(full_name: 'Maria Garcia', job_title: 'Designer',
                             country: 'Spain', salary: 100_000)
    result[:employee]
  end

  describe 'India deduction' do
    it 'applies 10% TDS for India' do
      result = SalaryCalculator.calculate(india_employee)
      expect(result[:tds]).to eq(10_000.0)
    end

    it 'returns correct net salary for India' do
      result = SalaryCalculator.calculate(india_employee)
      expect(result[:net_salary]).to eq(90_000.0)
    end

    it 'returns the gross salary unchanged' do
      result = SalaryCalculator.calculate(india_employee)
      expect(result[:gross_salary]).to eq(100_000.0)
    end
  end

  describe 'United States deduction' do
    it 'applies 12% TDS for United States' do
      result = SalaryCalculator.calculate(us_employee)
      expect(result[:tds]).to eq(12_000.0)
    end

    it 'returns correct net salary for United States' do
      result = SalaryCalculator.calculate(us_employee)
      expect(result[:net_salary]).to eq(88_000.0)
    end
  end

  describe 'other countries' do
    it 'applies no deduction for countries not in the rules' do
      result = SalaryCalculator.calculate(other_employee)
      expect(result[:tds]).to eq(0.0)
    end

    it 'returns net salary equal to gross for other countries' do
      result = SalaryCalculator.calculate(other_employee)
      expect(result[:net_salary]).to eq(100_000.0)
    end
  end
end
