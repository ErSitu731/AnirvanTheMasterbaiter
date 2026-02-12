Running tests
==============

Prerequisites
-------------
- Lua 5.1+ installed and available on your PATH (or use a Lua environment).

Quick run
---------
From repository root:

lua -e "package.path = package.path .. ';./?.lua;./anirvan/scripts/?.lua;./anirvan/scripts/components/?.lua;./anirvan/scripts/prefabs/?.lua'" -e "dofile('tests/run_tests.lua')"

Notes
-----
- Tests are simple Lua-based unit/integration checks for the `ragebait_controller` component and use a lightweight mocked `inst` object. Consider integrating with `busted` for richer test reporting and CI integration.
- If you add more components to test, expand `tests/run_tests.lua` to require and run them similarly.