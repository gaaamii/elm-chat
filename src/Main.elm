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
    { posterName : String
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


init : ( Model, Cmd Msg )
init =
    ( { talkList = [ { posterName = "とみざわ", message = "ピザ食いてえ", createdAt = "2018/01/27 13:00", imageUrl = "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" }, { posterName = "伊達ちゃん", message = "ピザ食いてえ", createdAt = "2018/01/27 13:00", imageUrl = "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" } ]
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
                    { posterName = "伊達ちゃん"
                    , message = content
                    , imageUrl = "https://imgcp.aacdn.jp/img-c/680/auto/tipsplus/series/246/20160608_1465380998273.jpg"
                    , createdAt = "2018/01/27 13:00" -- 仮
                    }
                        :: talkList
            in
            ( { model | talkList = newList, content = "" }, Cmd.none )


viewTalk : Talk -> Html Msg
viewTalk talk =
    div [ Styles.talk ]
        [ div [ Styles.talkLeft ]
            [ img [ Styles.posterImg, src talk.imageUrl ] [] ]
        , div [ Styles.talkRight ]
            [ div [ Styles.posterName ] [ text talk.posterName ]
            , div [ Styles.message ] [ text talk.message ]
            , div [ Styles.talkFooter ]
                [ text talk.createdAt ]
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
        , div [ Styles.talk ]
            [ div [ Styles.talkLeft ]
                [ img [ Styles.posterImg, src "http://www.hochi.co.jp/photo/20170718/20170718-OHT1I50084-T.jpg" ] [] ]
            , div [ Styles.talkRight ]
                [ div [ Styles.posterName ] [ text "とみざわ" ]
                , div [ Styles.message ] [ text "ちょっと何言ってるかわかんないっす" ]
                , div [ Styles.talkFooter ]
                    [ text "2018/01/27 13:30"
                    , div [ Styles.buttons ]
                        [ button [ Styles.editButton ] [ text "編集" ]
                        , button [ Styles.deleteButton ] [ text "削除" ]
                        ]
                    ]
                ]
            ]
        ]



-- cf. 編集中はメッセージがtextarea表示になり、変更できるようになります


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
