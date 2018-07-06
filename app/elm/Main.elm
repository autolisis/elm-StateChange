module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Navigation exposing (Location)
import RouteUrl
import RouteUrl exposing (UrlChange, HistoryEntry(NewEntry))
import String
import Base64
import Result exposing (withDefault)


type alias Model =
    String


type Msg
    = Change String
    | Clear
    | Set String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newString ->
            ( newString, Cmd.none )

        Clear ->
            ( "", Cmd.none )

        Set newString ->
            ( newString, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Html.div
        []
        [ Html.h1 []
            [ Html.textarea [ placeholder model, onInput Change ] [ text model ]
            ]
        ]


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    Just (UrlChange NewEntry ("#" ++ Base64.encode current))


location2messages : Location -> List Msg
location2messages location =
    case String.dropLeft 1 location.hash of
        newString ->
            [ Set (Base64.decode newString |> withDefault "") ]


main =
    RouteUrl.program
        { init = ( "", Cmd.none )
        , subscriptions = (\_ -> Sub.none)
        , update = update
        , view = view
        , delta2url = delta2url
        , location2messages = location2messages
        }
