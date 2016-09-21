require_relative "employee"

class Manager < Employee
  def initialize(name, title, salary)
    super(name, title, salary)
    @employees = []
    @total_employees_salary = 0
  end

  def add_manager(name, title, salary)
    @employees << Manager.new(name, title, salary)
    @employees[-1].boss = self
    @total_employees_salary += salary
  end

  def add_employee(name, title, salary)
    @employees << Employee.new(name, title, salary, self)
    @total_employees_salary += salary
  end

  def bonus(multiplier)
    @total_employees_salary * multiplier
  end

end
