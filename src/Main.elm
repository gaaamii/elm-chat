module Main exposing (..)

import Html exposing (Html, button, div, img, program, text, textarea)
import Html.Attributes exposing (src, value)
import Html.Events exposing (onClick, onInput)
import List exposing (..)
import Styles as Styles


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Talk =
    { id : Int
    , posterId : Int
    , posterName : String
    , message : String
    , createdAt : String
    , imageUrl : String
    }


type alias Model =
    { talkList : List Talk
    , content : String
    }


type Msg
    = InputForm String
    | PostTalk
    | DeleteTalk Int


init : ( Model, Cmd Msg )
init =
    ( { talkList = [ { id = 1, posterId = 1, posterName = "とみざわ", message = "ピザ食いてえ", createdAt = "2018/01/27 13:00", imageUrl = "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" }, { id = 2, posterId = 2, posterName = "伊達ちゃん", message = "ピザ食いてえ", createdAt = "2018/01/27 13:00", imageUrl = "https://imgcp.aacdn.jp/img-c/680/auto/tipsplus/series/246/20160608_1465380998273.jpg" } ]
      , content = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ talkList, content } as model) =
    case msg of
        InputForm content ->
            ( { model | content = content }, Cmd.none )

        PostTalk ->
            let
                newList =
                    { id = List.length model.talkList + 1
                    , posterId = 1
                    , posterName = "とみざわ"
                    , message = content
                    , imageUrl = "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg"
                    , createdAt = "2018/01/27 13:00" -- 仮
                    }
                        :: talkList
            in
            ( { model | talkList = newList, content = "" }, Cmd.none )

        DeleteTalk talkId ->
            let
                newList =
                    List.filter (\talk -> talk.id /= talkId) model.talkList
            in
            ( { model | talkList = newList }, Cmd.none )


viewTalk : Talk -> Html Msg
viewTalk talk =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src talk.imageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text talk.posterName ]
            , div [ Styles.message ] [ text talk.message ]
            , div [] [ viewTalkFooter { talkId = talk.id, isMine = isMy talk, createdAt = talk.createdAt } ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ Styles.mainWrap ]
        [ div [ Styles.postForm ]
            [ div [ Styles.formLeft ]
                [ img [ Styles.selfImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] []
                ]
            , div [ Styles.formRight ]
                [ textarea [ Styles.formArea, onInput (\str -> InputForm str), value model.content ] []
                , button [ Styles.postButton, onClick PostTalk ] [ text "投稿！" ]
                ]
            ]
        , div [] <| List.map viewTalk model.talkList
        ]



-- cf. 編集中はメッセージがtextarea表示になり、変更できるようになります


type alias TalkMeta =
    { talkId : Int, isMine : Bool, createdAt : String }


viewTalkFooter : TalkMeta -> Html Msg
viewTalkFooter meta =
    if meta.isMine then
        div [ Styles.talkFooter ]
            [ text "2018/01/27 13:30"
            , div [ Styles.buttons ]
                [ button [ Styles.editButton ] [ text "編集" ]
                , button [ Styles.deleteButton, onClick (DeleteTalk meta.talkId) ] [ text "削除" ]
                ]
            ]
    else
        text ""



-- 自分はID: 1ということで


isMy : Talk -> Bool
isMy talk =
    talk.posterId == 1


viewEditingTalk : Html msg
viewEditingTalk =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text "とみざわ" ]
            , textarea [ Styles.editingMessage, value "僕ちゃんとピッザって言いましたよ" ] []
            , div [ Styles.talkFooter ]
                [ text "2018/01/27 13:30"
                , div [ Styles.buttons ]
                    [ button [ Styles.editButton ] [ text "完了" ]
                    , button [ Styles.deleteButton ] [ text "削除" ]
                    ]
                ]
            ]
        ]
