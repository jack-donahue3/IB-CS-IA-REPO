package projecttracker.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity 
@Table(name = "users")
public class User {
    //columns in db
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String email;

    @JsonIgnore
    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false)
    private Role role;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;


    //constructors
    //jpa required empty constructor
    protected User() {}

    //actual user constructor
    public User(String firstName, String lastName, String email, String passwordHash, Role role) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
    }

    //getters
    public Integer getId() {return id;}
    public String getFirstName() {return firstName;}
    public String getLastName() {return lastName;}
    public String getEmail() {return email;}
    public String getPasswordHash() {return passwordHash;}
    public Role getRole() {return role;}
    public LocalDateTime getCreatedAt() {return createdAt;}

    //setters
    public void setFirstName(String firstName) {this.firstName = firstName;}
    public void setLastName(String lastName) {this.lastName = lastName;}
    public void setEmail(String email) {this.email = email;}
    public void setPasswordHash(String passwordHash) {this.passwordHash = passwordHash;}
    public void setRole(Role role) {this.role = role;}
}