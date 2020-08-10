package wiki.lgxzj.java.util.sqlparser;

import wiki.lgxzj.java.model.bo.sqlparser.ValidateResult;

interface SqlParser {
     ValidateResult validate(String sql);
}