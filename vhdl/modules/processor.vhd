----------------------------------------------------------------------
-- Project      :   Eater Computer
-- Module       :   processor
-- Description  :   alu and alu registers TODO
--
-- Authors      :   Philipp Semmel
-- Created      :   02.05.2023
-- Last update  :   02.05.2023
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.comp_pkg.ALL;

ENTITY processor IS
    PORT(
        clk          : IN    std_ulogic;
        rst          : IN    std_ulogic;
        -- control signals in
        load_reg_a   : IN    std_ulogic;
        out_en_reg_a : IN    std_ulogic;
        load_reg_b   : IN    std_ulogic;
        sub          : IN    std_ulogic;
        out_en_alu   : IN    std_ulogic;
        flag_in      : IN    std_ulogic;
        -- control signals out
        carry        : OUT   std_ulogic;
        zero         : OUT   std_ulogic;
        -- data
        data_reg_a   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        data_reg_b   : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
        data_alu     : INOUT std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
    );
END ENTITY processor;

ARCHITECTURE RTL OF processor IS

    COMPONENT alu_register
        PORT(
            clk          : IN     std_ulogic;
            rst          : IN     std_ulogic;
            load         : IN     std_ulogic;
            out_en       : IN     std_ulogic;
            data         : INOUT  std_logic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);
            data_out_alu : BUFFER std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT alu_register;

    COMPONENT alu
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
    END COMPONENT alu;

    SIGNAL a_to_alu, b_to_alu : std_ulogic_vector(DATA_WORD_WIDTH - 1 DOWNTO 0);

BEGIN

    reg_a : COMPONENT alu_register
        PORT MAP(
            clk          => clk,
            rst          => rst,
            load         => load_reg_a,
            out_en       => out_en_reg_a,
            data         => data_reg_a,
            data_out_alu => a_to_alu
        );

    reg_b : COMPONENT alu_register
        PORT MAP(
            clk          => clk,
            rst          => rst,
            load         => load_reg_b,
            out_en       => '0',
            data         => data_reg_b,
            data_out_alu => b_to_alu
        );

    al_unit : COMPONENT alu
        PORT MAP(
            clk       => clk,
            rst       => rst,
            sub       => sub,
            out_en    => out_en_alu,
            flag_in   => flag_in,
            data      => data_alu,
            data_in_a => a_to_alu,
            data_in_b => b_to_alu,
            carry     => carry,
            zero      => zero
        );

END ARCHITECTURE RTL; 