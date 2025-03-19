set print pretty
set print asm-demangle on

# Helpers for es2panda (arkcompiler ets frontend) debugging
source ~/.gdb.d/es2panda-views.gdb

# Helpers from https://github.com/joneschrisg/rr-workbench
source ~/.gdb.d/stl-views.gdb

# dashboard from https://github.com/cyrus-and/gdb-dashboard
source ~/.gdb.d/dashboard.gdb

dashboard -layout source
