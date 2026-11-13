package projecttracker.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import projecttracker.model.Role;
import projecttracker.model.User;
import projecttracker.repository.UserRepository;

@Component
public class DataSeed implements CommandLineRunner{
    private final UserRepository userRepository;

    public DataSeed(UserRepository userRepository) {this.userRepository = userRepository;}

    @Override 
    public void run(String... args) {
        User teacher = userRepository.findByEmail("teacher@example.com").orElseGet(() -> userRepository.save(new User("Test", "Teacher", "teacher@example.com", "example password", Role.TEACHER)));

        User student = userRepository.findByEmail("student@example.com").orElseGet(() -> userRepository.save(new User("Test", "Student", "student@example.com", "example password", Role.STUDENT)));

        System.out.println("Teacher ID: " + teacher.getId() + "\nStudent ID: " + student.getId());
    }
}
