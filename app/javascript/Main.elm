module Main exposing (main)

import Browser
import Html exposing (..)
import Http
import Json.Decode as Decode


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Todo =
    String


type alias Model =
    { todos : List Todo
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model []
    , fetchTodos
    )



-- UPDATE


type Msg
    = NoOp
    | FetchedAll (Result Http.Error (List Todo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        FetchedAll result ->
            case result of
                Ok todos ->
                    ( { model | todos = todos }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view { todos } =
    div []
        [ todosView todos ]


todosView : List Todo -> Html Msg
todosView todos =
    ul [] (List.map todoView todos)


todoView : Todo -> Html Msg
todoView title =
    li [] [ text title ]



-- HTTP


fetchTodos : Cmd Msg
fetchTodos =
    Http.send FetchedAll <|
        Http.get "http://localhost:3000/todos" <|
            Decode.list todoDecoder


todoDecoder : Decode.Decoder Todo
todoDecoder =
    Decode.field "title" Decode.string
