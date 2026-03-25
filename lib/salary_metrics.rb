require_relative 'database'

class SalaryMetrics
  def self.by_country(country)
    salaries = fetch_salaries(DB[:employees].where(country: country))
    return nil if salaries.empty?

    {
      country: country,
      minimum: salaries.min.round(2),
      maximum: salaries.max.round(2),
      average: average(salaries)
    }
  end

  def self.by_job_title(job_title)
    salaries = fetch_salaries(DB[:employees].where(job_title: job_title))
    return nil if salaries.empty?

    {
      job_title: job_title,
      average:   average(salaries)
    }
  end

  private_class_method def self.fetch_salaries(dataset)
    dataset.select(:salary).all.map { |r| r[:salary].to_f }
  end

  private_class_method def self.average(salaries)
    (salaries.sum / salaries.size).round(2)
  end
end
