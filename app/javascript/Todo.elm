module Main exposing (main)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Debug exposing (crash)

main = view

view =
  div []
  [ input
    [ type_ "text"] []
    , button [] [text "Submit"]
    , button [] [text "Remove All"]
    , div [] []
  ]
