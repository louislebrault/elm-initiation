module Image exposing (Image, imageListDecoder)


import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required, requiredAt)

type alias Image =
    { thumbnailUrl : String
    , url : String
    }

imageDecoder : Decoder Image -- 1
imageDecoder =
    Decode.succeed Image
        |> requiredAt [ "urls", "thumb" ] string -- 2
        |> requiredAt [ "urls", "regular" ] string -- 3

imageListDecoder : Decoder (List Image) -- 4
imageListDecoder =
    field "results" (list imageDecoder)
