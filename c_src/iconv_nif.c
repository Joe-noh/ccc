#include <errno.h>
#include <string.h>
#include <erl_nif.h>
#include <iconv.h>

#include "utils.h"

static ERL_NIF_TERM ccc_iconv_convert(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    ErlNifBinary input, from_code, to_code;

    enif_inspect_binary(env, argv[1], &from_code);
    enif_inspect_binary(env, argv[2], &to_code);

    char* from = malloc(from_code.size * (sizeof(char)+1));
    from = strcpy(from, (const char*)from_code.data);
    from[from_code.size] = '\0';

    char* to = malloc(to_code.size * (sizeof(char)+1));
    to = strcpy(to, (const char*)to_code.data);
    to[to_code.size] = '\0';

    iconv_t cd = iconv_open((const char*)to, (const char*)from);

    free(from);
    free(to);

    if ((int)cd == -1) {
        if (errno == EINVAL) {
            char* message = "invalid from_code and/or to_code";
            return utils_error_message(env, message);
        }
    }

    enif_inspect_binary(env, argv[0], &input);

    size_t inbytes_left = input.size;
    size_t outbytes_left = 4*inbytes_left;
    char* out_buf = calloc(outbytes_left, 1);
    char* output = out_buf;

    int res = (int)iconv(cd, (char **)(&input.data), &inbytes_left, &out_buf, &outbytes_left);

    if (res == -1) {
        switch(errno) {
        case EILSEQ:
            return utils_error_message(env, "invalid multibyte sequence");
        case EINVAL:
            return utils_error_message(env, "incomplete multibyte sequence");
        case E2BIG:
            return utils_error_message(env, "no more room");
        default:
            return utils_error_message(env, strerror(errno));
        }
    }

    res = (int)iconv_close(cd);

    if (res == -1) {
        return utils_error_message(env, strerror(errno));
    }

    return utils_chars_to_binary(env, (const unsigned char*)output, strlen(output));
}

static ErlNifFunc nif_functions[] = {
    {"convert", 3, ccc_iconv_convert}
};

ERL_NIF_INIT(Elixir.CCC.Converter, nif_functions, 0, 0, 0, NULL);
