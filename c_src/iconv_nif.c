#include <errno.h>
#include <string.h>
#include <erl_nif.h>
#include <iconv.h>

#include "utils.h"

typedef struct {
    iconv_t cd;
} ccc_iconv;

static ErlNifResourceType* ccc_iconv_type = NULL;

static ERL_NIF_TERM ccc_ok(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM ccc_iconv_open(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    ccc_iconv* icv = enif_alloc_resource(ccc_iconv_type, sizeof(ccc_iconv));
    ErlNifBinary from_code, to_code;

    enif_inspect_binary(env, argv[0], &from_code);
    enif_inspect_binary(env, argv[1], &to_code);

    icv->cd = iconv_open((const char *)from_code.data, (const char *)to_code.data);

    if ((int)(icv->cd) == -1) {
        if (errno == EINVAL) {
            char* message = "invalid from_code and/or to_code";
            return utils_error_message(env, message);
        }
    }

    ERL_NIF_TERM resource = enif_make_resource(env, icv);
    enif_release_resource(icv);

    return resource;
}

static ERL_NIF_TERM ccc_iconv_close(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    ccc_iconv* icv;
    enif_get_resource(env, argv[0], ccc_iconv_type, (void **)&icv);

    int res = (int)iconv_close(icv->cd);

    if (res == -1) {
        return utils_error_message(env, strerror(errno));
    }

    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM ccc_iconv_convert(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    ccc_iconv* icv;
    enif_get_resource(env, argv[0], ccc_iconv_type, (void **)&icv);

    ErlNifBinary input;
    enif_inspect_binary(env, argv[1], &input);

    size_t inbytes_left = input.size;
    size_t outbytes_left = 4*inbytes_left;
    char* out_buf = calloc(outbytes_left, 1);
    char* output = out_buf;

    int res = (int)iconv(icv->cd, (char **)(&input.data), &inbytes_left, &out_buf, &outbytes_left);

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

    return utils_chars_to_binary(env, (const unsigned char*)output, strlen(output));
}

static int on_load(ErlNifEnv* env, void** priv, ERL_NIF_TERM info) {
    ErlNifResourceType* rt;

    rt = enif_open_resource_type(env, "Elixir.CCC.Converter",  "ccc_iconv", NULL,
                                 ERL_NIF_RT_CREATE, NULL);
    if (!rt) { return -1; }

    ccc_iconv_type = rt;

    return 0;
}

static ErlNifFunc nif_functions[] = {
    {"nif_iconv_open", 2, ccc_iconv_open},
    {"nif_iconv_close", 1, ccc_iconv_close},
    {"nif_iconv_convert", 2, ccc_iconv_convert},
    {"nif_ok", 0, ccc_ok}
};

ERL_NIF_INIT(Elixir.CCC.Converter, nif_functions, on_load, 0, 0, NULL);
