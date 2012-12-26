#!/bin/bash

mvn clean package

mv target/benchmark-1.0-jar-with-dependencies.jar ./benchmark.jar