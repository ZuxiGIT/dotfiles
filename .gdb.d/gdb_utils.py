"""GDB memory-only string comparison convenience functions.

All functions inspect inferior memory and never execute inferior code:
  $_target_str_eq(A, B)
  $_target_mem_eq(A, B, LEN)
  $_target_str_len(A)
  $_target_str_view_eq(VIEW, STRING)

Use them in an expression or breakpoint condition, for example:
  break function if $_target_str_view_eq(name, "expected")

Interactive commands compare target memory with host-side quoted text:
  raw-str-eq ADDRESS STRING
  raw-mem-eq ADDRESS STRING LEN
  raw-str-len STRING
  raw-str-view-eq VIEW STRING
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


def _read_string_view(value):
    """Read a std::string_view's bytes from target memory without method calls."""
    if value.type.code == gdb.TYPE_CODE_REF:
        value = value.referenced_value()

    try:
        data = value['_M_str']
        size = int(value['_M_len'])
    except gdb.error:
        try:
            data = value['__data_']
            size = int(value['__size_'])
        except gdb.error as error:
            raise gdb.GdbError('expected a libstdc++ or libc++ std::string_view') from error

    if size < 0:
        raise gdb.GdbError('std::string_view has a negative size')
    return bytes(gdb.selected_inferior().read_memory(_address(data), size))


def _raw_argv(arg, expected, usage):
    """Parse exactly EXPECTED command-line arguments."""
    argv = gdb.string_to_argv(arg)
    if len(argv) != expected:
        raise gdb.GdbError('usage: {}'.format(usage))
    return argv


class TargetStrEq(gdb.Function):
    """$_target_str_eq(A, B): compare target NUL-terminated strings.

    Help:
      A and B must point to NUL-terminated byte strings in target memory.
      Returns 1 when equal; otherwise 0, including memory-read failures.
    """

    def __init__(self):
        super().__init__('_target_str_eq')

    def invoke(self, left, right):
        try:
            return int(_read_c_string(left) == _read_c_string(right))
        except gdb.MemoryError:
            return 0


class TargetMemEq(gdb.Function):
    """$_target_mem_eq(A, B, LEN): compare LEN target-memory bytes.

    Help:
      A and B must point to at least LEN readable bytes in target memory.
      Returns 1 when equal; otherwise 0, including negative lengths and
      memory-read failures.
    """

    def __init__(self):
        super().__init__('_target_mem_eq')

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


class TargetStrLen(gdb.Function):
    """$_target_str_len(A): length of a target NUL-terminated string.

    Help:
      A must point to a NUL-terminated string in target memory.  Returns its
      byte length, excluding the terminator, or 0 if it cannot be read.
    """

    def __init__(self):
        super().__init__('_target_str_len')

    def invoke(self, value):
        try:
            return len(_read_c_string(value))
        except gdb.MemoryError:
            return 0


class TargetStrViewEq(gdb.Function):
    """$_target_str_view_eq(VIEW, STRING): compare std::string_view and a C string.

    Help:
      VIEW is a libstdc++ or libc++ std::string_view.  STRING points to a
      NUL-terminated byte string; a GDB literal such as "expected" is valid.
      Returns 1 when their byte sequences are equal, otherwise 0.  It reads
      VIEW's data pointer and length directly and never calls inferior code.
    """

    def __init__(self):
        super().__init__('_target_str_view_eq')

    def invoke(self, view, string):
        try:
            return int(_read_string_view(view) == _read_c_string(string))
        except gdb.MemoryError:
            return 0


class RawStrEq(gdb.Command):
    """raw-str-eq ADDRESS STRING: compare target C string and host-side text.

    Help:
      ADDRESS evaluates to a target-memory pointer.  STRING remains in GDB
      Python, rather than being materialized in the inferior.  Prints 1 when
      the NUL-terminated target string equals STRING's UTF-8 bytes.
    """

    def __init__(self):
        super().__init__('raw-str-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        address, raw_string = _raw_argv(arg, 2, 'raw-str-eq ADDRESS "STRING"')
        try:
            result = _read_c_string(gdb.parse_and_eval(address)) == raw_string.encode()
        except gdb.MemoryError:
            result = False
        gdb.write('{}\n'.format(int(result)))


class RawMemEq(gdb.Command):
    """raw-mem-eq ADDRESS STRING LEN: compare target bytes and host-side text.

    Help:
      ADDRESS evaluates to a target-memory pointer.  STRING remains in GDB
      Python.  Prints 1 when the first LEN target bytes equal STRING's first
      LEN UTF-8 bytes; otherwise prints 0.
    """

    def __init__(self):
        super().__init__('raw-mem-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        address, raw_string, length = _raw_argv(arg, 3, 'raw-mem-eq ADDRESS "STRING" LEN')
        try:
            size = int(length, 0)
        except ValueError as error:
            raise gdb.GdbError('LEN must be an integer') from error
        raw_bytes = raw_string.encode()
        if size < 0 or size > len(raw_bytes):
            gdb.write('0\n')
            return
        try:
            target_bytes = bytes(gdb.selected_inferior().read_memory(
                _address(gdb.parse_and_eval(address)), size))
            result = target_bytes == raw_bytes[:size]
        except gdb.MemoryError:
            result = False
        gdb.write('{}\n'.format(int(result)))


class RawStrLen(gdb.Command):
    """raw-str-len STRING: count UTF-8 bytes in host-side quoted text.

    Help:
      STRING is parsed in GDB Python without accessing inferior memory.
    """

    def __init__(self):
        super().__init__('raw-str-len', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        (raw_string,) = _raw_argv(arg, 1, 'raw-str-len "STRING"')
        gdb.write('{}\n'.format(len(raw_string.encode())))


class RawStrViewEq(gdb.Command):
    """raw-str-view-eq VIEW STRING: compare std::string_view and host-side text.

    Help:
      VIEW is a libstdc++ or libc++ std::string_view expression.  STRING is
      held in GDB Python.  No native method is called and no NUL terminator is
      required for VIEW.
    """

    def __init__(self):
        super().__init__('raw-str-view-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        view, raw_string = _raw_argv(arg, 2, 'raw-str-view-eq VIEW "STRING"')
        try:
            result = _read_string_view(gdb.parse_and_eval(view)) == raw_string.encode()
        except gdb.MemoryError:
            result = False
        gdb.write('{}\n'.format(int(result)))


TargetStrEq()
TargetMemEq()
TargetStrLen()
TargetStrViewEq()
RawStrEq()
RawMemEq()
RawStrLen()
RawStrViewEq()
