module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (href)
import Url
import Url.Parser exposing (Parser, map, oneOf, s, top)



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key Home, Cmd.none )


type Page
    = Home
    | Cheatsheet
    | NotFound


pageToString : Page -> String
pageToString page =
    case page of
        Home ->
            "Home"

        Cheatsheet ->
            "Cheatsheet"

        NotFound ->
            "NotFound"


routeParser : Parser (Page -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map Cheatsheet (s "cheatsheet")
        ]



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model
                | page = url |> Url.Parser.parse routeParser >> Maybe.withDefault NotFound
              }
            , Cmd.none
            )



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "FP Handbook"
    , body =
        [ "The current page is: " ++ pageToString model.page |> text
        , ul []
            [ viewLink "/"
            , viewLink "/home"
            , viewLink "/cheatsheet"
            , viewLink "/other"
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
