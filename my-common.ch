Don't compare address of character with offset from the beginning of buffer.
@x
Trailing blanks are ignored. The value of |limit| must be strictly less
than |buf_size|, so that |buffer[buf_size-1]| is never filled.
@y
Trailing blanks are ignored. The value of |limit| must be less or equal
to |buffer_end|, so that |buffer[buf_size-1]| is never filled.
@z
