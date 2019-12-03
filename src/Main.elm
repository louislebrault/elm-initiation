module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Html.Attributes exposing (type_, class, src, style)
import Http
import Browser
import Image exposing (..)
import Http exposing (Error(..))

type alias Model =
    { searchTerms : String
    , images: List Image
    , message: String
    }

type Msg =
    InputChanged String
    | FormSubmitted
    | ResponseReceived (Result Http.Error (List Image))

init : () -> (Model, Cmd Msg)
init _ =
    ({ searchTerms = "", images = [], message = "" }, Cmd.none)

main: Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }

view : Model -> Html Msg
view model =
    div [class "container"]
        [ h1 [class "title"] [text "elm image search"]
        , viewForm
        , viewError model
        , viewResults model
        ]

viewForm : Html Msg
viewForm =
    form [ onSubmit FormSubmitted, style "margin-bottom" "1em" ]
        [ input
            [ type_ "text"
            , class "medium input"
            , onInput InputChanged
            ]
        []
    ]

viewError : Model -> Html Msg
viewError model =
    if (String.length model.message > 0)
    then div [class "notification is-danger"] [
        button [class "delete"] []
        ,text ("Voici l'erreur : " ++ model.message)
        ]
    else div [] []

viewResults : Model -> Html Msg
viewResults model =
    div [class "columns is-multiline"] (List.map viewThumbnail model.images)

viewThumbnail : Image -> Html Msg
viewThumbnail image =
    img [ src image.thumbnailUrl, class "column is-one-quarter" ] []


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        InputChanged value ->
            ( { model | searchTerms = value }, Cmd.none )

        FormSubmitted ->
            let
                httpCommand = Http.get
                        { url = "https://unsplash.noprod-b.kmt.orange.com"
                                ++ "/search/photos?query="
                                 ++ model.searchTerms
                    , expect = Http.expectJson ResponseReceived imageListDecoder }
            in
            ( model, httpCommand )


        ResponseReceived (Ok imageList) -> ( { model | images = imageList }, Cmd.none )

        ResponseReceived (Err error) ->( { model | message = (errorToString error)}, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

errorToString : Http.Error -> String
errorToString err =
    case err of
        Timeout ->
            "Timeout exceeded"

        NetworkError ->
            "Network error"

        BadStatus _ ->
            "Bad status error"

        BadBody _ ->
            "Bad body error"

        BadUrl url ->
            "Malformed url: " ++ url
