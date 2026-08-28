"""General GDB target-memory string helpers.

Functions read inferior memory only and never execute inferior code:
  $_Streq(A, B)
  $_Memeq(A, B, LEN)
  $_Strlen(A)
"""

import gdb


def _address(value):
    """Return the address represented by a pointer or array GDB value."""
    if value.type.code == gdb.TYPE_CODE_ARRAY:
        value = value.address
    return int(value)


def _read_c_string(value):
    """Read a NUL-terminated string from target memory."""
    inferior = gdb.selected_inferior()
    address = _address(value)
    result = bytearray()
    chunk_size = 256
    while True:
        chunk = bytes(inferior.read_memory(address + len(result), chunk_size))
        terminator = chunk.find(b"\0")
        if terminator >= 0:
            result.extend(chunk[:terminator])
            return bytes(result)
        result.extend(chunk)


class PyStrEq(gdb.Function):
    """$_Streq(A, B): compare target NUL-terminated strings.

    Help:
      A and B must point to NUL-terminated strings in target memory.
      Returns 1 when the strings are equal, otherwise 0.  Returns 0 when
      either string cannot be read.
    """

    def __init__(self):
        super().__init__("_Streq")

    def invoke(self, left, right):
        try:
            return int(_read_c_string(left) == _read_c_string(right))
        except gdb.MemoryError:
            return 0


class PyMemEq(gdb.Function):
    """$_Memeq(A, B, LEN): compare LEN target-memory bytes.

    Help:
      A and B must point to at least LEN readable bytes in target memory.
      Returns 1 when the byte sequences are equal, otherwise 0.  Negative
      lengths and memory-read failures return 0.
    """

    def __init__(self):
        super().__init__("_Memeq")

    def invoke(self, left, right, length):
        try:
            size = int(length)
            if size < 0:
                return 0
            inferior = gdb.selected_inferior()
            return int(inferior.read_memory(_address(left), size) ==
                       inferior.read_memory(_address(right), size))
        except gdb.MemoryError:
            return 0


class PyStrLen(gdb.Function):
    """$_Strlen(A): length of a target NUL-terminated string.

    Help:
      A must point to a NUL-terminated string in target memory.  Returns its
      length in bytes, excluding the terminator.  Returns 0 if it cannot be
      read.
    """

    def __init__(self):
        super().__init__("_Strlen")

    def invoke(self, value):
        try:
            return len(_read_c_string(value))
        except gdb.MemoryError:
            return 0


PyStrEq()
PyMemEq()
PyStrLen()
