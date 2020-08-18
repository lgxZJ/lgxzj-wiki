package wiki.lgxzj.java.util.dir;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import wiki.lgxzj.java.model.bo.backup.BackupEntity;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

public class DirectoryFileFinder {
    protected final static Logger logger = LogManager.getLogger(DirectoryFileFinder.class);
    protected final static int INFINITE = -1;

    public List<BackupEntity> directChildren(String dirUrl, boolean includeHidden) {
        Path dirPath = Paths.get(dirUrl);
        if (Files.notExists(dirPath, LinkOption.NOFOLLOW_LINKS)) {
            logger.warn("dir not exists, dir:{}", dirPath);
            return new ArrayList<>();
        }

        return recursiveChildren(dirUrl, 0, includeHidden);
    }

    private List<BackupEntity> filesToEntities(List<File> files) {
        return files.stream().map(this::fileToEntity).collect(Collectors.toList());
    }

    private BackupEntity fileToEntity(File file) {
        try {
            BasicFileAttributes fileAttrs = Files.readAttributes(file.toPath(), BasicFileAttributes.class);

            return BackupEntity.builder()
                    .name(file.getName())
                    .syncedSizeByte(file.length())
                    .syncedDate(new Date(fileAttrs.lastModifiedTime().toMillis()))
                    .syncedDurationMs(fileAttrs.lastModifiedTime().toMillis() - fileAttrs.creationTime().toMillis())
                    .build();
        } catch (IOException e) {
            logger.info("fileToEntity failed", e);
            return BackupEntity.builder().build();
        }
    }

    public List<BackupEntity> recursiveChildren(String dirUrl, int recursiveLevel, boolean includeHidden) {
        Path dirPath = Paths.get(dirUrl);
        if (Files.notExists(dirPath, LinkOption.NOFOLLOW_LINKS)) {
            logger.warn("dir not exists, dir:{}", dirPath);
            return new ArrayList<>();
        }

        return filesToEntities(recursiveChildrenNoCheck(dirUrl, recursiveLevel, includeHidden));
    }

    private List<File> recursiveChildrenNoCheck(String dirUrl, int recursiveLevel, boolean includeHidden) {
        File folder = new File(dirUrl);
        int nextLevel = recursiveLevel == DirectoryFileFinder.INFINITE ? DirectoryFileFinder.INFINITE : recursiveLevel - 1;

        List<File> result = new ArrayList<>();
        for (File file : folder.listFiles()) {
            if (file.isDirectory()) {
                if (recursiveLevel > 0) {
                    result.addAll(recursiveChildrenNoCheck(dirUrl + "/" + file.getName(), nextLevel, includeHidden));
                }
            }
            if (file.isFile()) {
                if (!file.isHidden() || (file.isHidden() && includeHidden)) {
                    result.add(file);
                } else {
                    logger.info("excluding hidden files: {}", file.getName());
                }
            }
        }

        return result;
    }

    public List<BackupEntity> recursiveChildren(String dirUrl, boolean includeHidden) {
        Path dirPath = Paths.get(dirUrl);
        if (Files.notExists(dirPath, LinkOption.NOFOLLOW_LINKS)) {
            logger.warn("dir not exists, dir:{}", dirPath);
            return new ArrayList<>();
        }

        return filesToEntities(recursiveChildrenNoCheck(dirUrl, DirectoryFileFinder.INFINITE, includeHidden));
    }
}
