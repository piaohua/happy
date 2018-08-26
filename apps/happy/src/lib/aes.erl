%%%-------------------------------------------------------------------
%% @doc aes 加密解密
%% @author piaohua<814004090@qq.com>
%% @end 2018-08-26 15:53:08
%%%-------------------------------------------------------------------
-module(aes).

%% API
-export([
         encrypto_aes_cbc/3
         ,encrypto_aes_cbc/4
         ,decrypto_aes_cbc/3
         ,decrypto_aes_cbc/4
         ,sha/2
         ,sha_example/0
         ,aes_example/0
        ]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

%% @doc aes 解密
%%
%% @spec: decrypto_aes_cbc(Ciphertext::binary() | list(), Key::binary(), Ivec::binary() ->
%%      {ok, PlainText::binary().
-spec decrypto_aes_cbc(Ciphertext, Key, Ivec) -> {ok, PlainText} when
    Ciphertext :: binary() | list(),
    Key :: binary(),
    Ivec :: binary(),
    PlainText :: binary().
decrypto_aes_cbc(Ciphertext, Key, Ivec) ->
    Charset = utf8,
    decrypto_aes_cbc(Ciphertext, Key, Ivec, Charset).

%% aes 解密
decrypto_aes_cbc(Ciphertext, Key, Ivec, _Charset) ->
    %Key2 = unicode:characters_to_list(Key, Charset),
    %%
    case is_list(Ciphertext) of
        true ->
            CipherBin = list_to_binary(Ciphertext);
        false ->
            CipherBin = Ciphertext
    end,

    PlainAndPadding = crypto:block_decrypt(aes_cbc,Key,Ivec,CipherBin),
    <<PosLen/integer>> = binary_part(PlainAndPadding,{size(PlainAndPadding),-1}),
    Len = byte_size(PlainAndPadding) - PosLen,
    <<PlainText:Len/binary, _:PosLen/binary>> = PlainAndPadding,
    {ok, PlainText}.

%% @doc aes 加密
%%
%% @spec: encrypto_aes_cbc(PlainText::binary() | list(), Key::binary(), Ivec::binary() ->
%%      {ok, PlainText::binary().
-spec encrypto_aes_cbc(PlainText, Key, Ivec) -> {ok, Ciphertext} when
    PlainText :: binary() | list(),
    Key :: binary(),
    Ivec :: binary(),
    Ciphertext :: binary().
encrypto_aes_cbc(PlainText, Key, Ivec) ->
    Charset = utf8,
    encrypto_aes_cbc(PlainText, Key, Ivec, Charset).

%% aes 加密
encrypto_aes_cbc(PlainText, Key, Ivec, _Charset) ->
    %%Key2 = unicode:characters_to_list(Key, Charset),
    %%
    %% 按AES规则，补位
    N = 8 - (byte_size(list_to_binary(PlainText)) rem 8),
    PlainText2 = lists:append(PlainText, get_padding(N)),
    %% 加密
    Ciphertext = crypto:block_encrypt(aes_cbc, Key, Ivec, PlainText2),
    {ok, Ciphertext}.

get_padding(N) ->
    case N of
        0 ->
            get_padding2(8,8,[]);
        Num ->
            get_padding2(Num,Num,[])
    end.

get_padding2(N, Val, PaddingList) when N > 0 ->
    get_padding2(N-1, Val, [Val] ++ PaddingList);
get_padding2(N, _Val,PaddingList) when N == 0 ->
    PaddingList.

%% @doc sha1 加密
%%
%% @spec: sha(RawData::binary(), SessionKey::binary() ->
%%      List::list() | [].
-spec sha(RawData, SessionKey) -> List | [] when
    RawData :: binary(),
    SessionKey :: binary(),
    List :: list().
sha(RawData, SessionKey) when is_binary(RawData), is_binary(SessionKey) ->
    <<Bin:160/integer>> = crypto:hash(sha, <<RawData/binary, SessionKey/binary>>),
    lists:flatten(io_lib:format("~40.16.0b", [Bin]));
sha(_, _) ->
    [].

sha_example() ->
    RawData = "{\"nickName\":\"Band\",\"gender\":1,\"language\":\"zh_CN\",\"city\":\"Guangzhou\",\"province\":\"Guangdong\",\"country\":\"CN\",\"avatarUrl\":\"http://wx.qlogo.cn/mmopen/vi_32/1vZvI39NWFQ9XM4LtQpFrQJ1xlgZxx3w7bQxKARol6503Iuswjjn6nIGBiaycAjAtpujxyzYsrztuuICqIM5ibXQ/0\"}",
    SessionKey = <<"HyVFkGl5F5OQWJZZaNzBBg==">>,
    %%75e81ceda165f4ffa64f4068af58c64b8f54b88c
    sha(list_to_binary(RawData), SessionKey).

aes_example() ->
    SessionKey = <<"tiihtNczf5v6AKRyjwEUhQ==">>,
    Ivec = <<"r7BXXKkLb8qrSNn05n0qiA==">>,
    EncryptedData = <<"CiyLU1Aw2KjvrjMdj8YKliAjtP4gsMZMQmRzooG2xrDcvSnxIMXFufNstNGTyaGS9uT5geRa0W4oTOb1WT7fJlAC+oNPdbB+3hVbJSRgv+4lGOETKUQz6OYStslQ142dNCuabNPGBzlooOmB231qMM85d2/fV6ChevvXvQP8Hkue1poOFtnEtpyxVLW1zAo6/1Xx1COxFvrc2d7UL/lmHInNlxuacJXwu0fjpXfz/YqYzBIBzD6WUfTIF9GRHpOn/Hz7saL8xz+W//FRAUid1OksQaQx4CMs8LOddcQhULW4ucetDf96JcR3g0gfRK4PC7E/r7Z6xNrXd2UIeorGj5Ef7b1pJAYB6Y5anaHqZ9J6nKEBvB4DnNLIVWSgARns/8wR2SiRS7MNACwTyrGvt9ts8p12PKFdlqYTopNHR1Vf7XjfhQlVsAJdNiKdYmYVoKlaRv85IfVunYzO0IKXsyl7JCUjCpoG20f0a04COwfneQAGGwd5oa+T8yO5hzuyDb/XcxxmK01EpqOyuxINew==">>,
    Ciphertext = base64:decode(EncryptedData),
    Key = base64:decode(SessionKey),
    Iv = base64:decode(Ivec),
    decrypto_aes_cbc(Ciphertext, Key, Iv).
%% {ok,<<"{\"openId\":\"oGZUI0egBJY1zhBYw2KhdUfwVJJE\",\"nickName\":\"Band\",\"gender\":1,\"language\":\"zh_CN\",\"city\":\"Guangzhou\",\"province\":\"Guangdong\",\"country\":\"CN\",\"avatarUrl\":\"http://wx.qlogo.cn/mmopen/vi_32/aSKcBBPpibyKNicHNTMM0qJVh8Kjgiak2AHWr8MHM4WgMEm7GFhsf8OYrySdbvAMvTsw3mo8ibKicsnfN5pRjl1p8HQ/0\",\"unionId\":\"ocMvos6NjeKLIBqg5Mr9QjxrP1FA\",\"watermark\":{\"timestamp\":1477314187,\"appid\":\"wx4f4bc4dec97d474b\"}}">>}
