module Image exposing (Image, imageListDecoder, Format(..), filterImages)

-- declare a custom type Format in the module Image; the possible builders are Portrait, Landscape and Any.

-- export this type and its constructors with exposing (Format(..), …​)

-- import this type and its constructors into Main, with the same syntax

-- add a format field to the model

-- give it an initial value of "Any"

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required, requiredAt)

type alias Image =
    { thumbnailUrl : String
    , url : String
    , width : Int
    , height : Int
    }

type Format
  = Portait
  | Landscape
  | Any

imageDecoder : Decoder Image
imageDecoder =
    Decode.succeed Image
        |> requiredAt [ "urls", "thumb" ] string
        |> requiredAt [ "urls", "regular" ] string
        |> requiredAt [ "height" ] int
        |> requiredAt [ "width" ] int

imageListDecoder : Decoder (List Image)
imageListDecoder =
    field "results" (list imageDecoder)

filterImages : Format -> List Image -> List Image
filterImages format images =
  case format of
    Any -> images
    Portait -> List.filter (\image -> image.height > image.width) images
    Landscape -> List.filter (\image -> image.height < image.width) images
