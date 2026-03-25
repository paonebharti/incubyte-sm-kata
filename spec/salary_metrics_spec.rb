require 'spec_helper'

RSpec.describe SalaryMetrics do
  before(:each) do
    Employee.create(full_name: 'Priya Sharma',  job_title: 'Engineer', country: 'India',         salary: 60_000)
    Employee.create(full_name: 'Rahul Gupta',   job_title: 'Engineer', country: 'India',         salary: 80_000)
    Employee.create(full_name: 'Anjali Singh',  job_title: 'Manager',  country: 'India',         salary: 100_000)
    Employee.create(full_name: 'John Doe',      job_title: 'Manager',  country: 'United States', salary: 120_000)
    Employee.create(full_name: 'Jane Smith',    job_title: 'Designer', country: 'United States', salary: 90_000)
  end

  describe '.by_country' do
    it 'returns minimum salary for the given country' do
      result = SalaryMetrics.by_country('India')
      expect(result[:minimum]).to eq(60_000.0)
    end

    it 'returns maximum salary for the given country' do
      result = SalaryMetrics.by_country('India')
      expect(result[:maximum]).to eq(100_000.0)
    end

    it 'returns average salary for the given country' do
      result = SalaryMetrics.by_country('India')
      expect(result[:average]).to eq(80_000.0)
    end

    it 'includes the country in the result' do
      result = SalaryMetrics.by_country('India')
      expect(result[:country]).to eq('India')
    end

    it 'returns correct metrics for United States' do
      result = SalaryMetrics.by_country('United States')
      expect(result[:minimum]).to eq(90_000.0)
      expect(result[:maximum]).to eq(120_000.0)
      expect(result[:average]).to eq(105_000.0)
    end
  end

	describe '.by_job_title' do
    it 'returns average salary for a given job title' do
      result = SalaryMetrics.by_job_title('Engineer')
      expect(result[:average]).to eq(70_000.0)
    end

    it 'includes the job title in the result' do
      result = SalaryMetrics.by_job_title('Engineer')
      expect(result[:job_title]).to eq('Engineer')
    end

    it 'calculates correct average across countries for a job title' do
      result = SalaryMetrics.by_job_title('Manager')
      expect(result[:average]).to eq(110_000.0)
    end
  end

	describe 'edge cases' do
    it 'returns nil for a country with no employees' do
      expect(SalaryMetrics.by_country('Antarctica')).to be_nil
    end

    it 'returns nil for a job title with no employees' do
      expect(SalaryMetrics.by_job_title('Astronaut')).to be_nil
    end

    it 'handles a country with a single employee' do
      Employee.create(full_name: 'Carlos Silva', job_title: 'Engineer',
                      country: 'Brazil', salary: 50_000)
      result = SalaryMetrics.by_country('Brazil')
      expect(result[:minimum]).to eq(result[:maximum])
      expect(result[:average]).to eq(50_000.0)
    end
  end
end
