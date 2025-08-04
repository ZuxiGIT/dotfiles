set print pretty
set print asm-demangle on

# Helpers for es2panda (arkcompiler ets frontend) debugging
source ~/.gdb.d/es2panda-views.gdb

# Helpers from https://github.com/joneschrisg/rr-workbench
source ~/.gdb.d/stl-views.gdb

# dashboard from https://github.com/cyrus-and/gdb-dashboard
# source ~/.gdb.d/dashboard.gdb
#
# dashboard -layout source
# dashboard source -style highlight-line True
# dashboard source -style path True

define rr
    tui disable
    tui enable
end

tui enable
layout src
winheight src -15
focus next

python
import gdb
import re

def stop_handler(event):
    frame_name = gdb.selected_frame().name()
    if re.search("(^std::.*)|(^boost::.*)|(^__gnu_cxx::.*)|(^__sanitizer::.*)|(^__ubsan::.*)|(^operator new)", frame_name) != None:
        gdb.execute("step")
        return

    symtab = gdb.selected_frame().find_sal().symtab
    if symtab is None:
        return

    fullname = symtab.fullname()

    matches = ["libsanitizer", "sysdeps", "/usr/include/", "ubsan", "include/c++", "/malloc"]
    if any(x in fullname for x in matches):
        gdb.execute("step")
        return

    objfile = symtab.objfile.filename

    if "libubsan.so" in objfile:
        gdb.execute("step")
        return

gdb.events.stop.connect(stop_handler)
end
