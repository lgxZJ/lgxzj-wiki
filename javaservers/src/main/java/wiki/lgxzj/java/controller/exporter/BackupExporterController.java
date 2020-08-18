package wiki.lgxzj.java.controller.exporter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.lgxzj.java.model.vo.FeResponse;
import wiki.lgxzj.java.service.BackupService;

@RestController
@RequestMapping(path = "/exporter/backup")
public class BackupExporterController {

    @Autowired
    private BackupService backupService;

    @GetMapping(path = "/metrics")
    public FeResponse getBackupMetrics() {


        //  metrics:
        //      lgxzj_backup_size{src="wordpress"} counter
        //      lgxzj_backup_timestamp{src="wordpress"} counter
        //      lgxzj_backup_duration{src="wordpress"} counter
        return new FeResponse();
    }
}
