module Data.Menu exposing (..)

-- TYPES

import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline as Decode


type alias Menu =
    { dishes : List Dish
    }


type alias Dish =
    { title : String
    , photo_thumb : String
    , url : String
    , weight : Int
    , energy : Int
    , carbohydrates : Int
    , proteins : Int
    , fats : Int
    , ingredients : List String
    }



-- CONVERSION


menuDecoder : Decoder Menu
menuDecoder =
    Decode.map Menu (Decode.list dishDecoder)


dishDecoder : Decoder Dish
dishDecoder =
    Decode.succeed Dish
        |> Decode.required "title" string
        |> Decode.required "photo_thumb" string
        |> Decode.required "url" string
        |> Decode.optional "weight" int 0
        |> Decode.optional "energy" int 0
        |> Decode.optional "carbohydrates" int 0
        |> Decode.optional "proteins" int 0
        |> Decode.optional "fats" int 0
        |> Decode.required "ingredients" (Decode.list string)
