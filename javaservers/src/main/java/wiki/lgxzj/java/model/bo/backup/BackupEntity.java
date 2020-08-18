package wiki.lgxzj.java.model.bo.backup;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

@Data
@Builder
public class BackupEntity {

    @Builder.Default
    private String name = "error";

    @Builder.Default
    private Date syncedDate = new Date();

    @Builder.Default
    private Long syncedDurationMs = 0L;

    @Builder.Default
    private Long syncedSizeByte = 0L;
}
