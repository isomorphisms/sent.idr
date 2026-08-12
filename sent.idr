module sent

import Data.List
import Data.Maybe
import Data.String
import System
import System.File

record Slide where
  constructor MkSlide
  text  : List String
  image : Maybe String

unescape : String -> String
unescape s = case unpack s of
  '\\' :: rest => pack rest
  _            => s

imageName : String -> Maybe String
imageName s = case unpack s of
  '@' :: rest => Just (pack rest)
  _           => Nothing

paragraphs : List String -> List (List String)
paragraphs = go [] where
  go : List String -> List String -> List (List String)
  go now [] = if null now then [] else [reverse now]
  go now (line :: rest) =
    if line == "" then (if null now then [] else [reverse now]) ++ go [] rest
    else if isPrefixOf "#" line then go now rest
    else go (line :: now) rest

parse : String -> List Slide
parse = map slide . paragraphs . lines where
  slide : List String -> Slide
  slide raw = MkSlide (map unescape raw) (case raw of
    first :: _ => imageName first
    []         => Nothing)

dumpSlide : Slide -> String
dumpSlide (MkSlide _ (Just path)) = "[image " ++ path ++ "]"
dumpSlide (MkSlide text Nothing)  = joinBy "\n" text

dump : List Slide -> String
dump = joinBy "\n\n" . map dumpSlide

clamp : Nat -> Nat -> Nat
clamp count n = if count == 0 then 0 else min n (count `minus` 1)

at : Nat -> List a -> Maybe a
at Z     (x :: _)  = Just x
at (S n) (_ :: xs) = at n xs
at _     []        = Nothing

showSlide : List Slide -> Nat -> IO ()
showSlide slides n = case at n slides of
  Nothing => pure ()
  Just slide => do
    putStr "\x1b[2J\x1b[H"
    putStrLn (dumpSlide slide)
    putStrLn "\n[n/Enter/Space next, p previous, r reload, q quit]"

covering
loadAnd : String -> Bool -> Maybe Nat -> IO ()

covering
present : String -> List Slide -> Nat -> IO ()
present source slides n = do
  showSlide slides n
  command <- getLine
  case command of
    "q" => pure ()
    "p" => present source slides (n `minus` 1)
    "h" => present source slides (n `minus` 1)
    "k" => present source slides (n `minus` 1)
    "r" => if source == "-" then do
             putStrLn "sent: Cannot reload from stdin. Use a file!"
             present source slides n
           else loadAnd source False (Just n)
    _   => present source slides (clamp (length slides) (n + 1))

loadAnd source dumping start = do
  result <- readFile (if source == "-" then "/dev/stdin" else source)
  case result of
    Left err => putStrLn ("sent: Unable to read '" ++ source ++ "': " ++ show err)
    Right input => case parse input of
      [] => putStrLn "sent: No slides in file"
      slides => if dumping
                   then putStrLn (dump slides)
                   else present source slides (clamp (length slides) (fromMaybe 0 start))

usage : IO ()
usage = putStrLn "usage: sent [--dump] [FILE]"

covering
main : IO ()
main = do
  args <- getArgs
  case drop 1 args of
    []                 => loadAnd "-" False Nothing
    ["-"]              => loadAnd "-" False Nothing
    [file]             => loadAnd file False Nothing
    ["--dump"]         => loadAnd "-" True Nothing
    ["--dump", file]   => loadAnd file True Nothing
    _                  => usage
