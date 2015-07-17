@echo off

"documentation/gamsdocs.exe" main.gms > "documentation/documentation.md"

pandoc -t html -s -o documentation/documentation.html documentation/documentation.md
