/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

lexer grammar KyuubiSqlBaseLexer;

@members {
   /**
    * Verify whether current token is a valid decimal token (which contains dot).
    * Returns true if the character that follows the token is not a digit or letter or underscore.
    *
    * For example:
    * For char stream "2.3", "2." is not a valid decimal token, because it is followed by digit '3'.
    * For char stream "2.3_", "2.3" is not a valid decimal token, because it is followed by '_'.
    * For char stream "2.3W", "2.3" is not a valid decimal token, because it is followed by 'W'.
    * For char stream "12.0D 34.E2+0.12 "  12.0D is a valid decimal token because it is followed
    * by a space. 34.E2 is a valid decimal token because it is followed by symbol '+'
    * which is not a digit or letter or underscore.
    */
   public boolean isValidDecimal() {
     int nextChar = _input.LA(1);
     if (nextChar >= 'A' && nextChar <= 'Z' || nextChar >= '0' && nextChar <= '9' ||
       nextChar == '_') {
       return false;
     } else {
       return true;
     }
   }
 }

SEMICOLON: ';';

AND: 'AND';
BQ: '`';
BY: 'BY';
COMMA: ',';
DOT: '.';
EQ  : '=' | '==';
NSEQ: '<=>';
NEQ : '<>';
NEQJ: '!=';
LT  : '<';
LTE : '<=' | '!>';
GT  : '>';
GTE : '>=' | '!<';
LEFT_PAREN: '(';
RIGHT_PAREN: ')';
OR: 'OR';

DESC: 'DESC';
DESCRIBE: 'DESCRIBE';
FROM: 'FROM';

LIKE: 'LIKE';

KYUUBI: 'KYUUBI';
KYUUBIADMIN: 'KYUUBIADMIN';

ORDER: 'ORDER';
SELECT: 'SELECT';
SESSION: 'SESSION';
SYSTEM_JDBC_CATALOGS: 'SYSTEM.JDBC.CATALOGS';
SYSTEM_JDBC_SCHEMAS: 'SYSTEM.JDBC.SCHEMAS';
TABLE_CAT: 'TABLE_CAT';
TABLE_CATALOG: 'TABLE_CATALOG';
TABLE_SCHEM: 'TABLE_SCHEM';

WHERE: 'WHERE';

BACKQUOTED_IDENTIFIER
    : '`' ( ~'`' | '``' )* '`'
    ;

DECIMAL_VALUE
    : DECIMAL_DIGITS {isValidDecimal()}?
    ;

INTEGER_VALUE
    : DIGIT+
    ;

IDENTIFIER
    : [A-Za-z_$0-9\u0080-\uFFFF]*?[A-Za-z_$\u0080-\uFFFF]+?[A-Za-z_$0-9\u0080-\uFFFF]*
    ;

STRING
    : '\'' ( ~('\''|'\\') | ('\\' .) )* '\''
    | 'R\'' (~'\'')* '\''
    | 'R"'(~'"')* '"'
    ;

fragment DIGIT
    : [0-9]
    ;

fragment DECIMAL_DIGITS
    : DIGIT+ '.' DIGIT*
    | '.' DIGIT+
    ;

fragment LETTER
    : [A-Z]
    ;

SIMPLE_COMMENT
    : '--' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

BRACKETED_COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

WS  : [ \r\n\t]+ -> channel(HIDDEN)
    ;

// Catch-all for anything we can't recognize.
// We use this to be able to ignore and recover all the text
// when splitting statements with DelimiterLexer
UNRECOGNIZED
    : .
    ;
