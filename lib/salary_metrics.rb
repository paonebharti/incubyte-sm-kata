require_relative 'database'

class SalaryMetrics
  def self.by_country(country)
    rows = DB[:employees].where(country: country).select(:salary).all

    return nil if rows.empty?

    salaries = rows.map { |r| r[:salary].to_f }

    {
      country: country,
      minimum: salaries.min.round(2),
      maximum: salaries.max.round(2),
      average: (salaries.sum / salaries.size).round(2)
    }
  end

	def self.by_job_title(job_title)
    rows = DB[:employees].where(job_title: job_title).select(:salary).all

    return nil if rows.empty?

    salaries = rows.map { |r| r[:salary].to_f }

    {
      job_title: job_title,
      average:   (salaries.sum / salaries.size).round(2)
    }
  end
end
