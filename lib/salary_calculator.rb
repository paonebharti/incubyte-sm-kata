class SalaryCalculator
  DEDUCTION_RATES = {
    'India' => 0.10,
    'United States' => 0.12
  }.freeze

  def self.calculate(employee)
    gross = employee.salary.to_f
    rate  = DEDUCTION_RATES[employee.country] || 0.0
    tds   = (gross * rate).round(2)
    net   = (gross - tds).round(2)

    {
      employee_id:  employee.id,
      gross_salary: gross,
      tds:          tds,
      net_salary:   net,
      country:      employee.country
    }
  end
end
