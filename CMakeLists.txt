cmake_minimum_required(VERSION 3.21)

project(vhdl_test)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

enable_testing()
include(Dart)

include (ghdl)

ghdl_ecp5(vhdl_test
    SOURCES
        adder.vhdl
        adder_ulx3s.vhdl
    TOP
        adder_ulx3s
    CONSTRAINTS
        ulx3s_v20.lpf
    FPGA_SIZE
        85
    FPGA_PACKAGE
        CABGA381
)

ghdl_test(adder_tb
    SOURCES
        adder.vhdl
        adder_tb.vhdl
    TOP adder_tb
)