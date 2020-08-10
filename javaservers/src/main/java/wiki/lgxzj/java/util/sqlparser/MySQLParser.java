package wiki.lgxzj.java.util.sqlparser;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TGSqlParser;
import wiki.lgxzj.java.model.bo.sqlparser.ValidateResult;
import wiki.lgxzj.java.util.json.JsonSerializer;

public class MySQLParser implements SqlParser {
    @Override
    public ValidateResult validate(String sql) {
        TGSqlParser mysqlParser = new TGSqlParser(EDbVendor.dbvmysql);
        mysqlParser.setSqltext(sql);

        int ret = mysqlParser.parse();
        if (ret == 0) {
            return new ValidateResult(true, "valid MySQL");
        } else {
            return new ValidateResult(false, JsonSerializer.toString(mysqlParser.getSyntaxErrors()));
        }
    }
}
