require 'spec_helper'

RSpec.describe SalaryCalculator do
  let(:india_employee) do
    result = Employee.create(full_name: 'Priya Sharma', job_title: 'Engineer',
                             country: 'India', salary: 100_000)
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
end
