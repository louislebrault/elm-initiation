module TestImage exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Image exposing (..)


suite : Test
suite =
    describe "The Image module"
        [ describe "filterImages"
            [ test "any case" <|
                \_ ->
                    let
                        portaitImage = Image "" "600x800.com" 600 800
                        landscapeImage = Image "" "800x600.com" 800 600
                        images = [landscapeImage, portaitImage]
                    in
                        Expect.equal (filterImages Any images) images
            , test "portait case" <|
                \_ ->
                    let
                        portaitImage = Image "" "600x800.com" 600 800
                        landscapeImage = Image "" "800x600.com" 800 600
                        images = [landscapeImage, portaitImage]
                    in
                        Expect.equal (filterImages Portait images) [ portaitImage ]
            , test "landscape case" <|
                \_ ->
                    let
                        portaitImage = Image "" "600x800.com" 600 800
                        landscapeImage = Image "" "800x600.com" 800 600
                        images = [landscapeImage, portaitImage]
                    in
                        Expect.equal (filterImages Landscape images) [ landscapeImage ]
            ]
        ]
