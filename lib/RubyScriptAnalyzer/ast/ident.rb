module RubyScriptAnalyzer
  IDENT_CLASS_NAME = {

    'ALIAS' => 'RubyScriptAnalyzer::Ast::Alias_item',
    'AND' => 'RubyScriptAnalyzer::Ast::And_item',
    'ARGS' => 'RubyScriptAnalyzer::Ast::Args',
    'ARGSCAT' => 'RubyScriptAnalyzer::Ast::Argscat',
    'ARGSPUSH' => 'RubyScriptAnalyzer::Ast::Argspush',
    'ARGS_AUX' => 'RubyScriptAnalyzer::Ast::Args_aux',
    'ARRAY' => 'RubyScriptAnalyzer::Ast::Array_item',
    'ATTRASGN' => 'RubyScriptAnalyzer::Ast::Attrasgn',
    'BACK_REF' => 'RubyScriptAnalyzer::Ast::Back_ref',
    'BEGIN' => 'RubyScriptAnalyzer::Ast::Begin_item',
    'BLOCK' => 'RubyScriptAnalyzer::Ast::Block',
    'BLOCK_PASS' => 'RubyScriptAnalyzer::Ast::Block_pass',
    'BREAK' => 'RubyScriptAnalyzer::Ast::Break_item',
    'CALL' => 'RubyScriptAnalyzer::Ast::Call',
    'CASE' => 'RubyScriptAnalyzer::Ast::Case_item',
    'CASE2' => 'RubyScriptAnalyzer::Ast::Case2_item',
    'CDECL' => 'RubyScriptAnalyzer::Ast::Cdecl',
    'CLASS' => 'RubyScriptAnalyzer::Ast::Class_item',
    'COLON2' => 'RubyScriptAnalyzer::Ast::Colon2',
    'COLON3' => 'RubyScriptAnalyzer::Ast::Colon3',
    'CONST' => 'RubyScriptAnalyzer::Ast::Const_item',
    'CVAR' => 'RubyScriptAnalyzer::Ast::Cvar',
    'CVASGN' => 'RubyScriptAnalyzer::Ast::Cvasgn',
    'DASGN' => 'RubyScriptAnalyzer::Ast::Dasgn',
    'DASGN_CURR' => 'RubyScriptAnalyzer::Ast::Dasgn_curr',
    'DEFINED' => 'RubyScriptAnalyzer::Ast::Defined',
    'DEFN' => 'RubyScriptAnalyzer::Ast::Defn',
    'DEFS' => 'RubyScriptAnalyzer::Ast::Defs',
    'DOT2' => 'RubyScriptAnalyzer::Ast::Dot2',
    'DOT3' => 'RubyScriptAnalyzer::Ast::Dot3',
    'DREGX' => 'RubyScriptAnalyzer::Ast::Dregx',
    'DSTR' => 'RubyScriptAnalyzer::Ast::Dstr',
    'DSYM' => 'RubyScriptAnalyzer::Ast::Dsym',
    'DVAR' => 'RubyScriptAnalyzer::Ast::Dvar',
    'DXSTR' => 'RubyScriptAnalyzer::Ast::Dxstr',
    'ENSURE' => 'RubyScriptAnalyzer::Ast::Ensure_item',
    'ERRINFO' => 'RubyScriptAnalyzer::Ast::Errinfo',
    'EVSTR' => 'RubyScriptAnalyzer::Ast::Evstr',
    'FALSE' => 'RubyScriptAnalyzer::Ast::False_item',
    'FCALL' => 'RubyScriptAnalyzer::Ast::Fcall',
    'FLIP2' => 'RubyScriptAnalyzer::Ast::Flip2',
    'FLIP3' => 'RubyScriptAnalyzer::Ast::Flip3',
    'FOR' => 'RubyScriptAnalyzer::Ast::For_item',
    'FOR_MASGN' => 'RubyScriptAnalyzer::Ast::For_masgn_item',
    'GASGN' => 'RubyScriptAnalyzer::Ast::Gasgn',
    'GVAR' => 'RubyScriptAnalyzer::Ast::Gvar',
    'HASH' => 'RubyScriptAnalyzer::Ast::Hash_item',
    'IASGN' => 'RubyScriptAnalyzer::Ast::Iasgn',
    'IF' => 'RubyScriptAnalyzer::Ast::If_item',
    'ITER' => 'RubyScriptAnalyzer::Ast::Iter',
    'IVAR' => 'RubyScriptAnalyzer::Ast::Ivar',
    'KW_ARG' => 'RubyScriptAnalyzer::Ast::Kw_arg',
    'LAMBDA' => 'RubyScriptAnalyzer::Ast::Lambda',
    'LASGN' => 'RubyScriptAnalyzer::Ast::Lasgn',
    'LAST' => 'RubyScriptAnalyzer::Ast::Last',
    'LIT' => 'RubyScriptAnalyzer::Ast::Lit',
    'LVAR' => 'RubyScriptAnalyzer::Ast::Lvar',
    'MASGN' => 'RubyScriptAnalyzer::Ast::Masgn',
    'MATCH' => 'RubyScriptAnalyzer::Ast::Match',
    'MATCH2' => 'RubyScriptAnalyzer::Ast::Match2',
    'MATCH3' => 'RubyScriptAnalyzer::Ast::Match3',
    'MODULE' => 'RubyScriptAnalyzer::Ast::Module_item',
    'NEXT' => 'RubyScriptAnalyzer::Ast::Next_item',
    'NIL' => 'RubyScriptAnalyzer::Ast::Nil_item',
    'NTH_REF' => 'RubyScriptAnalyzer::Ast::Nth_ref',
    'ONCE' => 'RubyScriptAnalyzer::Ast::Once',
    'OPCALL' => 'RubyScriptAnalyzer::Ast::Opcall',
    'OPT_ARG' => 'RubyScriptAnalyzer::Ast::Opt_arg',
    'OP_ASGN1' => 'RubyScriptAnalyzer::Ast::Op_asgn1',
    'OP_ASGN2' => 'RubyScriptAnalyzer::Ast::Op_asgn2',
    'OP_ASGN_AND' => 'RubyScriptAnalyzer::Ast::Op_asgn_and',
    'OP_ASGN_OR' => 'RubyScriptAnalyzer::Ast::Op_asgn_or',
    'OP_CDECL' => 'RubyScriptAnalyzer::Ast::Op_cdecl',
    'OR' => 'RubyScriptAnalyzer::Ast::Or_item',
    'POSTARG' => 'RubyScriptAnalyzer::Ast::Postarg',
    'POSTEXE' => 'RubyScriptAnalyzer::Ast::Postexe',
    'QCALL' => 'RubyScriptAnalyzer::Ast::Qcall',
    'REDO' => 'RubyScriptAnalyzer::Ast::Redo_item',
    'RESBODY' => 'RubyScriptAnalyzer::Ast::Resbody',
    'RESCUE' => 'RubyScriptAnalyzer::Ast::Rescue_item',
    'RETRY' => 'RubyScriptAnalyzer::Ast::Retry_item',
    'RETURN' => 'RubyScriptAnalyzer::Ast::Return_item',
    'SCLASS' => 'RubyScriptAnalyzer::Ast::Sclass',
    'SCOPE' => 'RubyScriptAnalyzer::Ast::Scope',
    'SELF' => 'RubyScriptAnalyzer::Ast::Self_item',
    'SPLAT' => 'RubyScriptAnalyzer::Ast::Splat',
    'STR' => 'RubyScriptAnalyzer::Ast::Str',
    'SUPER' => 'RubyScriptAnalyzer::Ast::Super_item',
    'TRUE' => 'RubyScriptAnalyzer::Ast::True_item',
    'UNDEF' => 'RubyScriptAnalyzer::Ast::Undef_item',
    'UNLESS' => 'RubyScriptAnalyzer::Ast::Unless_item',
    'UNTIL' => 'RubyScriptAnalyzer::Ast::Until_item',
    'VALIAS' => 'RubyScriptAnalyzer::Ast::Valias',
    'VALUES' => 'RubyScriptAnalyzer::Ast::Values',
    'VCALL' => 'RubyScriptAnalyzer::Ast::Vcall',
    'WHEN' => 'RubyScriptAnalyzer::Ast::When_item',
    'WHILE' => 'RubyScriptAnalyzer::Ast::While_item',
    'XSTR' => 'RubyScriptAnalyzer::Ast::Xstr',
    'YIELD' => 'RubyScriptAnalyzer::Ast::Yield_item',
    'ZARRAY' => 'RubyScriptAnalyzer::Ast::Zarray',
    'ZSUPER' => 'RubyScriptAnalyzer::Ast::Zsuper_item',
}
end
