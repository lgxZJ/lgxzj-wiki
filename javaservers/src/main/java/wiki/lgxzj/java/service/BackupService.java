package wiki.lgxzj.java.service;


import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Metrics;
import io.micrometer.prometheus.PrometheusConfig;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import org.apache.commons.collections4.MultiMap;
import org.apache.commons.collections4.keyvalue.MultiKey;
import org.apache.commons.collections4.map.MultiKeyMap;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import wiki.lgxzj.java.model.bo.backup.BackupEntity;
import wiki.lgxzj.java.util.common.Common;
import wiki.lgxzj.java.util.dir.DirectoryFileFinder;
import wiki.lgxzj.java.util.json.JsonSerializer;

import javax.annotation.PostConstruct;
import java.util.*;

@Service
public class BackupService implements ApplicationRunner {

    protected static final Logger logger = LogManager.getLogger(BackupService.class);

    private static String backupSizeCounterName = "lgxzj_backup_size";
    private static List<Counter> backupSizeCounters = new ArrayList<>();

    private static String backupTimestampCounterName = "lgxzj_backup_timestamp";
    private static List<Counter> backupTimestampCounters = new ArrayList<>();

    private static String backupDurationCounterName = "lgxzj_backup_duration";
    private static List<Counter> backupDurationCounters = new ArrayList<>();

    private static Map<String, String> optConfs = new HashMap<String, String>(){{
        put("exporterName", "backup-exporter");
        put("dirUrl", "/");
        put("backupSrc", "lgxzj");
        put("instanceName", "localhost");//TODO
        put("includeHidden", "true");
    }};

    @Value("${server.port}")
    private int serverPort;

    @Autowired
    private ApplicationArguments args;

    @Scheduled(cron = "0 * * * * *")
    public void refreshMetrics() {
        logger.info("scheduled, args:{}", JsonSerializer.toString(args));

        HashMap<String, List<Counter>> removed = removeOldMeters();
        logger.info("old metrics removed : {}", JsonSerializer.toString(removed));

        HashMap<String, List<Counter>> injected = injectNewMeters();
        logger.info("new metrics injected: {}", JsonSerializer.toString(injected));
    }

    private HashMap<String, List<Counter>> removeOldMeters() {
        final HashMap<String, List<Counter>> removedMeters = new HashMap<>();
        removedMeters.put(backupSizeCounterName, Common.deepCopy(backupSizeCounters));
        removedMeters.put(backupTimestampCounterName, Common.deepCopy(backupTimestampCounters));
        removedMeters.put(backupSizeCounterName, Common.deepCopy(backupDurationCounters));

        backupSizeCounters.forEach((counter) -> {
            Metrics.globalRegistry.remove(counter);
        });
        backupSizeCounters.clear();

        backupTimestampCounters.forEach((counter) -> {
            Metrics.globalRegistry.remove(counter);
        });
        backupTimestampCounters.clear();

        backupDurationCounters.forEach((counter) -> {
            Metrics.globalRegistry.remove(counter);
        });
        backupDurationCounters.clear();

        return removedMeters;
    }

    private String getInstaneName() {
        return optConfs.get("instanceName") + ":" + String.valueOf(this.serverPort);
    }

    private void appendSizeMetric(BackupEntity entity) {
        String counterName = "lgxzj_backup_size";
        Counter sizeCounter = Metrics.globalRegistry.counter(
                counterName,
                "src",
                optConfs.get("backupSrc"),
                "instance",
                getInstaneName(),
                "job",
                optConfs.get("exporterName"),
                "file",
                entity.getName()
        );
        sizeCounter.increment(entity.getSyncedSizeByte());
        backupSizeCounters.add(sizeCounter);
    }

    private void appendTimestampMetric(BackupEntity entity) {
        String counterName = "lgxzj_backup_timestamp";
        Counter timestampCounter = Metrics.globalRegistry.counter(
                counterName,
                "src",
                optConfs.get("backupSrc"),
                "instance",
                getInstaneName(),
                "job",
                optConfs.get("exporterName"),
                "file",
                entity.getName()
        );
        timestampCounter.increment(entity.getSyncedDate().getTime());
        backupTimestampCounters.add(timestampCounter);
    }

    private void appendDurationMetric(BackupEntity entity) {

        String counterName = "lgxzj_backup_duration";
        Counter durationCounter = Metrics.globalRegistry.counter(
                counterName,
                "src",
                optConfs.get("backupSrc"),
                "instance",
                getInstaneName(),
                "job",
                optConfs.get("exporterName"),
                "file",
                entity.getName()
        );
        durationCounter.increment(entity.getSyncedDurationMs());
        backupDurationCounters.add(durationCounter);
    }

    private HashMap<String, List<Counter>> injectNewMeters() {
        DirectoryFileFinder finder = new DirectoryFileFinder();
        String dirUrl = optConfs.get("dirUrl");
        boolean includeHidden = Boolean.parseBoolean(optConfs.get("includeHidden"));

        List<BackupEntity> fileEntities = finder.directChildren(dirUrl, includeHidden);
        for (BackupEntity entity : fileEntities) {
            appendSizeMetric(entity);
            appendTimestampMetric(entity);
            appendDurationMetric(entity);
        }

        HashMap<String, List<Counter>> injected = new HashMap<>();
        injected.put(backupSizeCounterName, Common.deepCopy(backupSizeCounters));
        injected.put(backupTimestampCounterName, Common.deepCopy(backupTimestampCounters));
        injected.put(backupDurationCounterName, Common.deepCopy(backupDurationCounters));
        return injected;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        logger.info("parsing command line args");

        List<String> expectedArgs = new ArrayList<>(optConfs.keySet());
        Map<String, String> overloadedArgs = new HashMap<>();
        for (String arg : args.getOptionNames()) {
            if (expectedArgs.contains(arg)) {
                optConfs.put(arg, args.getOptionValues(arg).get(0));
                overloadedArgs.put(arg, args.getOptionValues(arg).get(0));
            }
        }

        logger.info("command line args overloaded: {}", JsonSerializer.toString(overloadedArgs));

        refreshMetrics();
    }
}
