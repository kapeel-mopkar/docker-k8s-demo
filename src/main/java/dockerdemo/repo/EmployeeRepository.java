package dockerdemo.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import dockerdemo.model.Employee;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
}
