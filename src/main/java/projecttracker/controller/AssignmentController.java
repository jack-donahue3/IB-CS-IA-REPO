package projecttracker.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import projecttracker.service.AssignmentService;
import projecttracker.model.Assignment;

@RestController
@RequestMapping("/api/assignments")
public class AssignmentController {

    private final AssignmentService assignmentService;

    //constructor for di
    public AssignmentController(AssignmentService assignmentService) {
        this.assignmentService = assignmentService;
    }

    //json format endpoints will follow
    public record AssignmentRequest(String title, String description, LocalDateTime dueDate, Integer points, Integer creatorId) {}

    //Get all request
    @GetMapping
    public List<Assignment> getAll() {return assignmentService.getAll();}
    
    //get by id request
    @GetMapping("/{id}")
    public Assignment getById(@PathVariable Integer id) {return assignmentService.getById(id);}

    //post assignment request
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Assignment create(@RequestBody AssignmentRequest request) {
        return assignmentService.create(request.title(), request.description(), request.dueDate(), request.points(), request.creatorId());
    }

    //put assignment request
    @PutMapping("/{id}")
    public Assignment update(@PathVariable Integer id, @RequestBody AssignmentRequest request) {
        return assignmentService.update(id, request.title(), request.description(), request.dueDate(), request.points());
    }

    //delete assignment request
    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Integer id) {
        assignmentService.delete(id);
    }

    //make service errors turn into http responses
    @ExceptionHandler(NoSuchElementException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(NoSuchElementException e) {
        return e.getMessage();
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleBadRequest(IllegalArgumentException e) {
        return e.getMessage();
    }
}