#!/bin/bash

cabal update

cabal install --only-dependencies
cabal configure
cabal build
