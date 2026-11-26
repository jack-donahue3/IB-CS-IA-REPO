package projecttracker.service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import jakarta.transaction.Transactional;
import java.util.Set;
import java.util.List;
import java.nio.file.Path;
import java.util.UUID;
import java.io.UncheckedIOException;
import projecttracker.repository.StudentAssignmentRepository;
import projecttracker.repository.SubmissionFileRepository;
import projecttracker.repository.SubmissionAttemptRepository;
import projecttracker.model.StudentAssignment;
import projecttracker.model.SubmissionAttempt;
import projecttracker.model.SubmissionFile;
import projecttracker.model.StudentAssignmentStatus;
import java.io.IOException;
import java.nio.file.Files;
import java.util.NoSuchElementException;
import java.util.ArrayList;
import java.util.Optional;
    
@Service
public class SubmissionService {
    //submission rules for file uploads
    private static final Set<String> ALLOWED_FILE_TYPES = Set.of("pdf", "docx", "txt","zip","png","jpg","jpeg");
    private static final long MAX_FILE_BYTES = 10485760;//10mb in bytes
    private static final int MAX_FILE_COUNT = 5;

    private final StudentAssignmentRepository studentAssignmentRepository;
    private final SubmissionFileRepository submissionFileRepository;
    private final SubmissionAttemptRepository submissionAttemptRepository;
    private final Path uploadDirectory;

    public SubmissionService(StudentAssignmentRepository studentAssignmentRepository,
        SubmissionFileRepository submissionFileRepository,
        SubmissionAttemptRepository submissionAttemptRepository,
        @Value("${app.upload-dir}") String uploadDirectory) {
        this.studentAssignmentRepository = studentAssignmentRepository;
        this.submissionFileRepository = submissionFileRepository;
        this.submissionAttemptRepository = submissionAttemptRepository;
        this.uploadDirectory = Path.of(uploadDirectory);
    }

    //process for student turning in a file
    @Transactional 
    public SubmissionAttempt submit(Integer studentAssignmentId, Integer userId, String textResponse, List<MultipartFile> files) {
        StudentAssignment studentAssignment = studentAssignmentRepository.findById(studentAssignmentId)
            .orElseThrow(() -> new IllegalArgumentException("Student assignment not found"));

            if (!studentAssignment.getStudent().getId().equals(userId)) {
                throw new SecurityException("You can only submit to your own assignments");
            }

            StudentAssignmentStatus status = studentAssignment.getCurrentStatus();
            if (status != StudentAssignmentStatus.NOT_SUBMITTED && status != StudentAssignmentStatus.NEEDS_RESUBMISSION) {
                throw new IllegalStateException("Cannot submit to assignment right now");
            }

            //make sure submission has either text or a file and skip empty files
            List<MultipartFile> validFiles = new ArrayList<>();
            if (files !=null) {
                for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
                    validFiles.add(file);
                }
            }
            }
            

            boolean hasText=textResponse != null && !textResponse.isBlank();
            if (!hasText && validFiles.isEmpty()) {
                throw new IllegalArgumentException("submission must have either text or a file");
            }

            if (validFiles.size() > MAX_FILE_COUNT) {
                throw new IllegalArgumentException("Cant upload more than " + MAX_FILE_COUNT + " files");
            }

            //find lastest attempt if possible
            Optional<SubmissionAttempt> latestAttempt = submissionAttemptRepository.findTopByStudentAssignmentIdOrderByAttemptNumberDesc(studentAssignment.getId());
            Integer attemptNumber = 1;
            if (latestAttempt.isPresent()) {
                attemptNumber = latestAttempt.get().getAttemptNumber() + 1;
            }

            //format text and save to db
            String cleanText = null;
            if (hasText) {
                cleanText = textResponse.strip();
            }
            SubmissionAttempt attempt = submissionAttemptRepository.save(new SubmissionAttempt(studentAssignment, attemptNumber, cleanText));

            //saves files to local upload directory.         uploads/<studentAssignmentId>/<attemptNumber>/file
        Path attemptDirectory = uploadDirectory.resolve(studentAssignment.getId().toString()).resolve(attemptNumber.toString());
        for (MultipartFile file : validFiles) {
            Path filePath = attemptDirectory.resolve(UUID.randomUUID().toString() + "." + StringUtils.getFilenameExtension(file.getOriginalFilename()));
            saveToDisk(file, filePath);

            String DBFilePath = uploadDirectory.relativize(filePath).toString();
            submissionFileRepository.save(new SubmissionFile(attempt,file.getOriginalFilename(),DBFilePath, (int) file.getSize()));
        }
        //change students assignment status to waiting for review
        studentAssignment.setCurrentStatus(StudentAssignmentStatus.AWAITING_REVIEW);
        studentAssignmentRepository.save(studentAssignment);

        return attempt;

    }

    //creates directories at specified path and transfers files to the path
    private void saveToDisk(MultipartFile file, Path filePath) {
        try {
            Files.createDirectories(filePath.getParent());
            file.transferTo(filePath);
        } catch (IOException e) {
            throw new RuntimeException("failed saving to disk", e);
        }
    }
    public List<SubmissionFile> getFiles(Integer attemptId) {
        return submissionFileRepository.findBySubmissionAttemptId(attemptId);
    }
}
