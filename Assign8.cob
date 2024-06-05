IDENTIFICATION DIVISION.
PROGRAM-ID. INTERPRETER-TESTS.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 VAR-Z PIC S9(9)V99 VALUE 0.

01 VAR-S PIC X(100).

01 AST-NODE.
   05 NODE-TYPE PIC X(10).

01 NUM-C-STRUCT.
   05 N PIC S9(9)V99.

01 STR-C-STRUCT.
   05 STR PIC X(50).

01 ID-C-STRUCT.
   05 S PIC X(50).

01 IF-C-STRUCT.
   05 TEST-EXPR PIC X(10).
   05 TEST-EXPR-N PIC S9(9)V99.
   05 THEN-EXPR PIC X(10).
   05 THEN-EXPR-N PIC S9(9)V99.
   05 ELSE-EXPR PIC X(10).
   05 ELSE-EXPR-N PIC S9(9)V99.

01 APP-C-STRUCT.
   05 EXP PIC X(10).
   05 ARG OCCURS 10 TIMES.
      10 ARG-N PIC S9(9)V99.

01 PRIM-OP-STRUCT.
   05 SYM PIC X(10).

PROCEDURE DIVISION.
    DISPLAY "Starting interpreter test cases..."

    PERFORM TEST-APPC

    STOP RUN.

TEST-NUMC SECTION.
    MOVE "NumC" TO NODE-TYPE
    MOVE 123.45 TO N
    PERFORM INTERP
    DISPLAY "Result of NUMC interpretation: " VAR-Z.

TEST-STRC SECTION.
    MOVE "StrC" TO NODE-TYPE
    MOVE "Hello, world!" TO STR
    PERFORM INTERP
    DISPLAY "Result of STRC interpretation: " VAR-S.

TEST-IDC SECTION.
    MOVE "IdC" TO NODE-TYPE
    MOVE "hi" TO S
    MOVE 100 TO VAR-Z
    PERFORM INTERP
    DISPLAY "Result of IDC interpretation: " VAR-Z.

TEST-IFC SECTION.
    MOVE "IfC" TO NODE-TYPE
    MOVE "NumC" TO TEST-EXPR
    MOVE 10 TO TEST-EXPR-N
    MOVE "NumC" TO THEN-EXPR
    MOVE 20 TO THEN-EXPR-N
    MOVE "NumC" TO ELSE-EXPR
    MOVE 30 TO ELSE-EXPR-N
    PERFORM INTERP
    DISPLAY "Result of IFC interpretation: " VAR-Z.

TEST-APPC SECTION.
    MOVE "AppC" TO NODE-TYPE
    MOVE "PrimOp" TO EXP
    MOVE "*" TO SYM
    MOVE 50 TO ARG-N(1)
    MOVE 10 TO ARG-N(2)
    PERFORM INTERP
    DISPLAY "Result of APPC interpretation: " VAR-Z.
   
INTERP SECTION.
   DISPLAY "Interpreting node with type: " NODE-TYPE
   EVALUATE NODE-TYPE
       WHEN "NumC"
           COMPUTE VAR-Z = N
       WHEN "StrC"
           MOVE STR TO VAR-S
       WHEN "IdC"
           MOVE S TO VAR-S
       WHEN "IfC"
           IF TEST-EXPR-N > 0
               COMPUTE VAR-Z = THEN-EXPR-N
           ELSE
               COMPUTE VAR-Z = ELSE-EXPR-N
           END-IF
       WHEN "AppC"
           IF SYM = "+"
               COMPUTE VAR-Z = ARG-N(1) + ARG-N(2)
           END-IF
           IF SYM = "-"
               COMPUTE VAR-Z = ARG-N(1) - ARG-N(2)
           END-IF
           IF SYM = "*"
               MULTIPLY ARG-N(1) BY ARG-N(2) GIVING VAR-Z
           END-IF
       WHEN OTHER
           DISPLAY "Unknown node type: " NODE-TYPE
   END-EVALUATE.
   DISPLAY "Result String: " VAR-S.
   DISPLAY "Result: " VAR-Z.

   STOP RUN.
   
