require_relative 'database'

class Employee
  REQUIRED_FIELDS = %i[full_name job_title country salary].freeze

  attr_reader :id, :full_name, :job_title, :country, :salary

  def initialize(attrs = {})
    @id        = attrs[:id]
    @full_name = attrs[:full_name]
    @job_title = attrs[:job_title]
    @country   = attrs[:country]
    @salary    = attrs[:salary]
  end

  def valid?
    errors.empty?
  end

  def errors
    REQUIRED_FIELDS.each_with_object([]) do |field, errs|
      value = send(field)
      errs << "#{field} is required" if value.nil? || value.to_s.strip.empty?
    end.tap do |errs|
      errs << 'salary must be positive' if salary && salary.to_f <= 0
    end
  end
end
