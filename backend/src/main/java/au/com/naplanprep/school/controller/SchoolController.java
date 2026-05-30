package au.com.naplanprep.school.controller;

import au.com.naplanprep.common.ApiResponse;
import au.com.naplanprep.school.entity.School;
import au.com.naplanprep.school.repository.SchoolRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/v1/schools")
@RequiredArgsConstructor
public class SchoolController {

    private final SchoolRepository schoolRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<List<School>>> list(
            @RequestParam(required = false) String search) {
        List<School> schools = (search != null && !search.isBlank())
                ? schoolRepository.findByNameContainingIgnoreCaseOrderByNameAsc(search)
                : schoolRepository.findAllByOrderByNameAsc();
        return ResponseEntity.ok(ApiResponse.success(schools));
    }

    @PostMapping
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<ApiResponse<School>> create(@RequestBody Map<String, String> body) {
        School school = School.builder()
                .name(body.get("name"))
                .state(body.get("state"))
                .build();
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success(schoolRepository.save(school)));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('PLATFORM_ADMIN')")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        schoolRepository.deleteById(id);
        return ResponseEntity.ok(ApiResponse.success(null));
    }
}
