----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   alu
-- Description  :   continuously add a and b or subtrachts if sub is high
--                  outputs sum oder difference if out_en high else high-z
--                  synchronously saves carry and zero bit in reg if flag_in is high
--                  flag reg can be reset  
--
-- Authors      :   Philipp Semmel
-- Created      :   26.03.2023
-- Last update  :   04.05.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY alu IS
    PORT(
        clk       : IN    std_ulogic;
        rst       : IN    std_ulogic;
        sub       : IN    std_ulogic;
        out_en    : IN    std_ulogic;
        flag_in   : IN    std_ulogic;
        data      : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        data_in_a : IN    std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        data_in_b : IN    std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        carry     : OUT   std_ulogic;
        zero      : OUT   std_ulogic
    );
END ENTITY alu;

ARCHITECTURE RTL OF alu IS

    COMPONENT generic_register IS
        GENERIC(
            WORD_WIDTH : natural
        );
        PORT(
            clk      : IN  std_ulogic;
            rst      : IN  std_ulogic;
            data_in  : IN  std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0);
            load     : IN  std_ulogic;
            data_out : OUT std_ulogic_vector(WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT generic_register;

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

    SIGNAL a, b, sum                   : unsigned(DATA_WORD_WIDTH DOWNTO 0);
    SIGNAL flag_out                    : std_ulogic_vector(1 DOWNTO 0);
    SIGNAL carry_flag_in, zero_flag_in : std_ulogic;
    SIGNAL dout                        : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    -- input wiring
    a <= resize(unsigned(data_in_a), DATA_WORD_WIDTH + 1);
    b <= resize(unsigned(data_in_b), DATA_WORD_WIDTH + 1);

    -- calc
    sum           <= a - b WHEN sub = '1' ELSE a + b;
    carry_flag_in <= sum(DATA_WORD_WIDTH);
    zero_flag_in  <= '1' WHEN is_all(sum(7 DOWNTO 0), '0') ELSE '0';

    flag_reg : COMPONENT generic_register
        GENERIC MAP(
            WORD_WIDTH => 2
        )
        PORT MAP(
            clk        => clk,
            rst        => rst,
            data_in(0) => carry_flag_in,
            data_in(1) => zero_flag_in,
            load       => flag_in,
            data_out   => flag_out
        );

    buf : COMPONENT generic_tri_state_buffer
        GENERIC MAP(
            WORD_WIDTH => DATA_WORD_WIDTH
        )
        PORT MAP(
            out_en   => out_en,
            data_in  => std_ulogic_vector(sum(DATA_WORD_WIDTH - 1 DOWNTO 0)),
            data_out => dout
        );

    -- output wiring
    carry <= flag_out(0);
    zero  <= flag_out(1);
    data  <= to_stdlogicvector(dout);

END ARCHITECTURE RTL; 