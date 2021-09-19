function(ghdl_ecp5 NAME)
    set(singleValueArgs TOP CONSTRAINTS FPGA_SIZE FPGA_PACKAGE)
    set(multiValueArgs SOURCES YOSYS_OPTIONS NEXTPRN_OPTIONS)
    cmake_parse_arguments(GHDL "" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

    add_custom_target(${NAME} ALL
        DEPENDS ${NAME}.bit
    )

    list(TRANSFORM GHDL_SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")
    list(JOIN GHDL_SOURCES " " sources)

    add_custom_command(
        OUTPUT
            ${NAME}.bit
            ${NAME}.json
            ${NAME}.config
        COMMAND yosys 
            -p "ghdl ${sources} -e ${TOP}"
            -p "synth_ecp5 -json ${NAME}.json ${GHDL_YOSYS_OPTIONS} "
            ${GHDL_YOSYS_OPTIONS}
            > ${NAME}.yosys.out
	    COMMAND nextpnr-ecp5
            --${GHDL_FPGA_SIZE}k --package ${GHDL_FPGA_PACKAGE}
            --top ${GHDL_TOP}
            --lpf ${CMAKE_CURRENT_SOURCE_DIR}/${GHDL_CONSTRAINTS}
            --json ${NAME}.json
		    --textcfg ${NAME}.config
            ${GHDL_NEXTPNR_OPTIONS}
            2> ${NAME}.nextpnr.out
	    COMMAND ecppack --compress --freq 62.0
            --input ${NAME}.config --bit ${NAME}.bit
        DEPENDS ${GHDL_SOURCES}
    )
endfunction()

function(ghdl_test NAME)
    set(singleValueArgs TOP)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(GHDL "" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

    add_custom_target(${NAME} ALL
        DEPENDS work-obj93.cf
    )

    list(TRANSFORM GHDL_SOURCES PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

    add_custom_command(
        OUTPUT work-obj93.cf
        COMMAND ghdl analyze ${GHDL_SOURCES}
        DEPENDS ${GHDL_SOURCES}
    )

    add_test(
        NAME ${NAME}
        COMMAND ghdl run ${GHDL_TOP} --assert-level=error
    )
endfunction()
