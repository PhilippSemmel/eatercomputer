----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   Program Coutner
-- Description  :   generic program counter
--                  synchornous write enable
--                  can be pressetted 
--                  count enable
--                  output enable with high impedance if disabled
--
-- Authors      :   Philipp Semmel
-- Created      :   20.02.2023
-- Last update  :   28.03.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;
USE ieee.math_real.ALL;

ENTITY program_counter IS
    PORT(
        clk      : IN    std_ulogic;
        rst      : IN    std_ulogic;
        load     : IN    std_ulogic;
        count_en : IN    std_ulogic;
        out_en   : IN    std_ulogic;
        count    : INOUT std_logic_vector(PROGRAMM_COUNTER_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY program_counter;

ARCHITECTURE RTL OF program_counter IS

    COMPONENT generic_counter
        GENERIC(
            COUNT_MAX : natural
        );
        PORT(
            clk       : IN     std_ulogic;
            rst       : IN     std_ulogic;
            count_en  : IN     std_ulogic;
            load      : IN     std_ulogic;
            count_in  : IN     unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            count_out : BUFFER unsigned(integer(ceil(log2(real(COUNT_MAX)))) - 1 DOWNTO 0);
            overflow  : OUT    std_ulogic
        );
    END COMPONENT generic_counter;

    COMPONENT generic_tri_state_buffer IS
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            out_en   : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_tri_state_buffer;

    SIGNAL count_out : unsigned(integer(ceil(log2(real(PROGRAMM_COUNTER_MAX_VALUE)))) - 1 DOWNTO 0);

BEGIN

    counter : COMPONENT generic_counter
        GENERIC MAP(
            COUNT_MAX => PROGRAMM_COUNTER_MAX_VALUE
        )
        PORT MAP(                                                     -- @suppress
            clk       => clk,
            rst       => rst,
            count_en  => count_en,
            load      => load,
            count_in  => unsigned(count),
            count_out => count_out
        );

    buf : COMPONENT generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => PROGRAMM_COUNTER_WORD_WIDTH
        )
        PORT MAP(
            out_en                      => out_en,
            data_in                     => std_ulogic_vector(count_out),
            to_stdlogicvector(data_out) => count
        );

    

END ARCHITECTURE RTL;
