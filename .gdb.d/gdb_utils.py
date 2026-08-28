"""General GDB string helpers.

Commands read inferior memory only and never execute inferior code:
  target-str-eq ADDRESS_A ADDRESS_B
  target-mem-eq ADDRESS_A ADDRESS_B LEN
  target-str-len ADDRESS

Commands compare target memory with quoted strings in the GDB command line:
  raw-str-eq ADDRESS STRING
  raw-mem-eq ADDRESS STRING LEN
  raw-str-len A
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
        raise gdb.GdbError("usage: {}".format(usage))
    return argv


class TargetStrEq(gdb.Command):
    """target-str-eq ADDRESS_A ADDRESS_B: compare target C strings.

    Help:
      Both arguments are GDB expressions that evaluate to target-memory
      pointers.  Prints 1 when their NUL-terminated byte strings are equal,
      otherwise 0.  It only inspects target memory.
      Example: target-str-eq first_ptr second_ptr
    """

    def __init__(self):
        super().__init__('target-str-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        left, right = _raw_argv(arg, 2, 'target-str-eq ADDRESS_A ADDRESS_B')
        try:
            result = _read_c_string(gdb.parse_and_eval(left)) == _read_c_string(gdb.parse_and_eval(right))
        except gdb.MemoryError:
            result = False
        gdb.write('{}\n'.format(int(result)))


class TargetMemEq(gdb.Command):
    """target-mem-eq ADDRESS_A ADDRESS_B LEN: compare target-memory bytes.

    Help:
      ADDRESS_A and ADDRESS_B are GDB expressions that evaluate to target
      pointers.  Prints 1 when their first LEN bytes are equal, otherwise 0.
      A negative LEN or a memory-read failure prints 0.
      Example: target-mem-eq first_ptr second_ptr 16
    """

    def __init__(self):
        super().__init__('target-mem-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        left, right, length = _raw_argv(arg, 3, 'target-mem-eq ADDRESS_A ADDRESS_B LEN')
        try:
            size = int(length, 0)
        except ValueError as error:
            raise gdb.GdbError('LEN must be an integer') from error
        if size < 0:
            gdb.write('0\n')
            return
        try:
            inferior = gdb.selected_inferior()
            result = inferior.read_memory(_address(gdb.parse_and_eval(left)), size) == \
                inferior.read_memory(_address(gdb.parse_and_eval(right)), size)
        except gdb.MemoryError:
            result = False
        gdb.write('{}\n'.format(int(result)))


class TargetStrLen(gdb.Command):
    """target-str-len ADDRESS: count bytes in a target C string.

    Help:
      ADDRESS is a GDB expression that evaluates to a target-memory pointer.
      Prints the NUL-terminated string length in bytes, excluding its
      terminator.  It prints 0 if target memory cannot be read.
      Example: target-str-len ptr
    """

    def __init__(self):
        super().__init__('target-str-len', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        (address,) = _raw_argv(arg, 1, 'target-str-len ADDRESS')
        try:
            result = len(_read_c_string(gdb.parse_and_eval(address)))
        except gdb.MemoryError:
            result = 0
        gdb.write('{}\n'.format(result))


class RawStrEq(gdb.Command):
    """raw-str-eq ADDRESS STRING: compare target and raw NUL-terminated strings.

    Help:
      ADDRESS is a GDB expression that evaluates to a target-memory pointer.
      STRING is a quoted command argument, kept in GDB Python rather than
      materialized in inferior memory.  Prints 1 when the target C string and
      STRING's UTF-8 bytes are equal, otherwise 0.
      Example: raw-str-eq ptr "hello world"
    """

    def __init__(self):
        super().__init__("raw-str-eq", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        address, raw_string = _raw_argv(arg, 2, 'raw-str-eq ADDRESS "STRING"')
        try:
            target_string = _read_c_string(gdb.parse_and_eval(address))
        except gdb.MemoryError:
            gdb.write("0\n")
            return
        gdb.write("{}\n".format(int(target_string == raw_string.encode())))


class RawMemEq(gdb.Command):
    """raw-mem-eq ADDRESS STRING LEN: compare target bytes and a raw string.

    Help:
      ADDRESS is a GDB expression that evaluates to a target-memory pointer.
      STRING is a quoted command argument, held outside inferior memory.
      Prints 1 when the first LEN target bytes equal STRING's first LEN UTF-8
      bytes.  It prints 0 when STRING is shorter than LEN or the target cannot
      be read.  A negative LEN is an error.
      Example: raw-mem-eq ptr "helium" 3
    """

    def __init__(self):
        super().__init__("raw-mem-eq", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        address, raw_string, length = _raw_argv(arg, 3, 'raw-mem-eq ADDRESS "STRING" LEN')
        try:
            size = int(length, 0)
        except ValueError as error:
            raise gdb.GdbError("LEN must be an integer") from error
        if size < 0:
            raise gdb.GdbError("LEN must not be negative")
        raw_bytes = raw_string.encode()
        if size > len(raw_bytes):
            gdb.write("0\n")
            return
        try:
            target_bytes = bytes(gdb.selected_inferior().read_memory(
                _address(gdb.parse_and_eval(address)), size))
        except gdb.MemoryError:
            gdb.write("0\n")
            return
        gdb.write("{}\n".format(int(target_bytes == raw_bytes[:size])))


class RawStrLen(gdb.Command):
    """raw-str-len A: count UTF-8 bytes in a raw GDB command-line string.

    Help:
      A is a quoted command argument, parsed without accessing inferior
      memory.  Prints its UTF-8 byte length.
      Example: raw-str-len "hello world"
    """

    def __init__(self):
        super().__init__("raw-str-len", gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        (value,) = _raw_argv(arg, 1, 'raw-str-len "A"')
        gdb.write("{}\n".format(len(value.encode())))


class RawStrViewEq(gdb.Command):
    """raw-str-view-eq VIEW STRING: compare a target std::string_view and raw text.

    Help:
      VIEW is a GDB expression whose value is a libstdc++ or libc++
      std::string_view.  STRING is a quoted command argument held outside the
      inferior.  Prints 1 when their UTF-8 byte sequences are equal, otherwise
      0.  It reads VIEW's data pointer and length directly; no native method is
      called and no NUL terminator is required.
      Example: raw-str-view-eq name "expected text"
    """

    def __init__(self):
        super().__init__('raw-str-view-eq', gdb.COMMAND_DATA)

    def invoke(self, arg, from_tty):
        view, raw_string = _raw_argv(arg, 2, 'raw-str-view-eq VIEW "STRING"')
        try:
            target_bytes = _read_string_view(gdb.parse_and_eval(view))
        except gdb.MemoryError:
            gdb.write('0\n')
            return
        gdb.write('{}\n'.format(int(target_bytes == raw_string.encode())))


TargetStrEq()
TargetMemEq()
TargetStrLen()
RawStrEq()
RawMemEq()
RawStrLen()
RawStrViewEq()
