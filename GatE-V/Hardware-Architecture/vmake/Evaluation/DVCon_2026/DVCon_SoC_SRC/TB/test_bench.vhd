--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
--%%                      Centre for Development of Advanced Computing                            %%
--%%                          Vellayambalam, Thiruvananthapuram.                                  %%
--%%==============================================================================================%%
--%% This confidential and proprietary software may be used only as authorised by a licensing     %%
--%% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
--%% publication, the following notice is applicable:                                             %%
--%% Copyright (c) 2024 C-DAC                                                                     %%
--%% ALL RIGHTS RESERVED                                                                          %%
--%% The entire notice above must be reproduced on all authorised copies.                         %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%% File Name        : test_bench.vhd                                                   	      %%
--%% Title            : DVCon System Testbench   						                          %%
--%% Author           : HDG, CDAC Thiruvananthapuram						                      %%
--%% Description      : Testbench for DVCon System vivado Implementation  		                  %%
--%% Version          : 00                                                                        %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%    Date                By              Version          Change Description                   %%
--%%                                                                                              %%
--%%                                                                                              %%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

library ieee ;
use ieee.std_logic_1164.all ;  
use ieee.numeric_std.all; 
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
use std.env.all;      
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity test_bench is
--  Port ( );
end test_bench;

architecture Behavioral of test_bench is

component ddr3_model 
port (
    
        rst_n      : in STD_LOGIC;
        ck         : in STD_LOGIC;
        ck_n       : in STD_LOGIC;
        cke        : in STD_LOGIC;
        cs_n       : in STD_LOGIC;
        ras_n      : in STD_LOGIC;
        cas_n      : in STD_LOGIC;
        we_n       : in STD_LOGIC;
        dm_tdqs    : inout STD_LOGIC_VECTOR (1 DOWNTO 0);
        ba         : in STD_LOGIC_VECTOR (2 DOWNTO 0);
        addr       : in STD_LOGIC_VECTOR (14 DOWNTO 0);
        dq         : inout STD_LOGIC_VECTOR (15 DOWNTO 0);
        dqs        : inout STD_LOGIC_VECTOR (1 DOWNTO 0);
        dqs_n      : inout STD_LOGIC_VECTOR (1 DOWNTO 0);
        tdqs_n     : out STD_LOGIC_VECTOR (1 DOWNTO 0);
        odt        : in STD_LOGIC
		
      );

end component; 

component Top 
port(    
	    --------------- External reset from pin ---------------------
	    rst		                   : in    std_logic;
	    soft_rst		           : in    std_logic;
	    rst_led		               : out    std_logic;
	    locked_led                 : out    std_logic;
	    --serial_rst_n	           : in    std_logic;

	    --------- differential clock for DDR controller -------------
	    clk_in1_p                  : in    std_logic; 		-- 50MHz  
	    clk_in1_n                  : in    std_logic; 		-- 50MHz  
	    
            ---------------------- DDR Pins ---------------------------
	    ddr3_addr	               : out STD_LOGIC_VECTOR              (14 DOWNTO 0);
	    ddr3_ba		               : out STD_LOGIC_VECTOR              (2 DOWNTO 0);
	    ddr3_ck_p	               : out STD_LOGIC_VECTOR              (0 to 0 );
	    ddr3_ck_n	               : out STD_LOGIC_VECTOR              (0 to 0 );
	    ddr3_cke	               : out STD_LOGIC_VECTOR              (0 DOWNTO 0);
	    ddr3_cs_n	               : out STD_LOGIC_VECTOR              (0 DOWNTO 0);
	    ddr3_ras_n	               : out STD_LOGIC;
	    ddr3_cas_n	               : out STD_LOGIC;
	    ddr3_we_n                  : out STD_LOGIC;
	    ddr3_dq		               : inout STD_LOGIC_VECTOR           (31 DOWNTO 0);
	    ddr3_dqs_p	               : inout STD_LOGIC_VECTOR           (3 DOWNTO 0);
	    ddr3_dqs_n	               : inout STD_LOGIC_VECTOR           (3 DOWNTO 0);
	    ddr3_dm		               : out STD_LOGIC_VECTOR             (3 DOWNTO 0);
	    ddr3_odt	               : out STD_LOGIC_VECTOR             (0 DOWNTO 0);
		
	    ddr3_reset_n               : out STD_LOGIC;
	    init_calib_complete        :  out std_logic;
		
        ------------------------ GMAC Pins --------------------------    
    	eth_rxck                : in  std_logic;  -- 125
        eth_txck                : OUT STD_LOGIC;
        eth_txd                 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        eth_tx_en               : OUT STD_LOGIC;
        eth_rxd                 : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        eth_rxctl               : IN  STD_LOGIC ;                 
        eth_mdio                : inout STD_LOGIC;
        eth_mdc                 : out STD_LOGIC;                  
        eth_phyrst_n            : out STD_LOGIC;
        eth_int_b               : in  STD_LOGIC;
		
    	------------------------ UART Pins ---------------------------
    	sin0	                   : IN  STD_LOGIC;  
    	sout0	                   : OUT STD_LOGIC;  	
          	
	    proc_beat                   : OUT STD_LOGIC
    
    ); 
end component;    

       
signal	    TRST 				       : STD_LOGIC;
signal      TCK					       : STD_LOGIC;
signal      TDI					       : STD_LOGIC;
signal      TMS					       : STD_LOGIC;
signal      TDO                        : STD_LOGIC;	    
signal	    soft_rst		           :    std_logic;
signal	    rst		                   :    std_logic;
signal	    rst_led		               :    std_logic;
signal	    locked_led                 :    std_logic;
signal	    serial_rst_n	           :    std_logic;
signal	    clk_in1_p                  :    std_logic    := '0'; 		-- 50MHz  
signal	    clk_in1_n                  :    std_logic    := '1'; 		-- 50MHz  
signal	    ddr3_addr	               :    STD_LOGIC_VECTOR              (14 DOWNTO 0);
signal	    ddr3_ba		               :    STD_LOGIC_VECTOR              (2 DOWNTO 0);
signal	    ddr3_ck_p	               :    STD_LOGIC_VECTOR              (0 to 0 );
signal	    ddr3_ck_n	               :    STD_LOGIC_VECTOR              (0 to 0 );
signal	    ddr3_cke	               :    STD_LOGIC_VECTOR              (0 DOWNTO 0);
signal	    ddr3_cs_n	               :    STD_LOGIC_VECTOR              (0 DOWNTO 0);
signal	    ddr3_ras_n	               :    STD_LOGIC;
signal	    ddr3_cas_n	               :    STD_LOGIC;
signal	    ddr3_we_n                  :    STD_LOGIC;
signal	    ddr3_dq		               :  STD_LOGIC_VECTOR           (31 DOWNTO 0);
signal	    ddr3_dqs_p	               :  STD_LOGIC_VECTOR           (3 DOWNTO 0);
signal	    ddr3_dqs_n	               :  STD_LOGIC_VECTOR           (3 DOWNTO 0);
signal	    ddr3_dm		               :     STD_LOGIC_VECTOR             (3 DOWNTO 0);
signal	    ddr3_dm_conv		               :     STD_LOGIC_VECTOR             (3 DOWNTO 0);
signal	    ddr3_odt	               :     STD_LOGIC_VECTOR             (0 DOWNTO 0);
signal	    ddr3_reset_n               :     STD_LOGIC;
signal	    init_calib_complete        :     std_logic;
signal    	eth_rxck                   :     std_logic := '0';  -- 125
signal        eth_txck                   :     STD_LOGIC;                                                                                                     
signal        eth_txd                    :     STD_LOGIC_VECTOR(3 DOWNTO 0);
signal        eth_tx_en                  :     STD_LOGIC;
signal        eth_rxd                    :     STD_LOGIC_VECTOR(3 DOWNTO 0);
signal        eth_rxctl                  :     STD_LOGIC ;                 
signal        eth_mdio                   :  STD_LOGIC;
signal        eth_mdc                    :   STD_LOGIC;                  
signal        eth_phyrst_n               :   STD_LOGIC;
signal        eth_int_b                  :   STD_LOGIC;
-- signal    	sin0	                   :     STD_LOGIC;  
-- signal    	sout0	                   :    STD_LOGIC;	
signal    	baudout_n                  :  STD_LOGIC;          
signal        WP                         :  std_logic;
signal        HOLD                       :  std_logic;  
signal    	gpio_port0                 :    std_logic_vector(15  downto 0);                                 
signal        sd_cmd                     :   STD_LOGIC; 
signal        sd_data                    :   STD_LOGIC_VECTOR(3 downto 0);         
signal        sd_cd                      :   STD_LOGIC; 
signal        sd_reset                   :   STD_LOGIC;                                      
signal        vselect                    :   STD_LOGIC;                            
signal        von18                      :   STD_LOGIC;                            
signal        von33                      :   STD_LOGIC;      
signal        oled_res                   :   STD_LOGIC;
signal        oled_vdd                   :   STD_LOGIC;
signal        oled_vbat                  :   STD_LOGIC;	
signal	    proc_beat                  :      STD_LOGIC	;

    signal uart_out					: std_logic;
    signal baudout_n_delay  		: std_logic;  
    signal baudout_pulse  			: std_logic;
    signal bit_count 				: std_logic_vector(3 downto 0);  
    signal uart_counter             : std_logic_vector(31 downto 0) := (others => '0');
    signal uart_data_flag           : std_logic; 
    signal uart_data_flag_delay     : std_logic;   
    signal file_write_pulse		    : std_logic;
    signal uart_shift_reg           : std_logic_vector(7 downto 0) := (others => '0');


	
begin

	--baudout_pulse <= (baudout_n and (not baudout_n_delay));  
   	------------------ Clock Generation -----------------------
    clk_in1_p            <=  NOT clk_in1_p  			after 2500 ps; --200MHz
	clk_in1_n            <=  NOT clk_in1_n  			after 2500 ps; --200MHz
	eth_rxck             <=  NOT eth_rxck  		        after 4000 ps; --125MHz
	---s_clk_eth1_125M        <=  NOT s_clk_eth1_125M  		after 4000 ps; --125MHz
		
	---------------- Reset Generation -------------------------
	reset_proc: process
	begin        
	-- hold reset state for 1000 ns.
		rst <= '0';
		--s_sd_power  <= '0';
		wait for 3000 ns;    --1000 ns; --- 300us for resetting NOR flash model
		rst <= '1';
		--s_sd_power  <= '1';
		wait;
	end process;
	
ddr3_dm_conv <= ddr3_dm when ddr3_dm /= x"0" else x"0";		

u_ddr3_model0:  ddr3_model 
port map (
    
        rst_n      => ddr3_reset_n,
        ck         => ddr3_ck_p(0),
        ck_n       => ddr3_ck_n(0),
        cke        => ddr3_cke(0),
        cs_n       => ddr3_cs_n(0),
        ras_n      => ddr3_ras_n,
        cas_n      => ddr3_cas_n,
        we_n       => ddr3_we_n,
        dm_tdqs    => ddr3_dm_conv(1 downto 0),
        ba         => ddr3_ba,
        addr       => ddr3_addr,
        dq         => ddr3_dq(15 downto 0),
        dqs        => ddr3_dqs_p(1 downto 0),
        dqs_n      => ddr3_dqs_n(1 downto 0),
        tdqs_n     => open,
        odt        => ddr3_odt(0)
		
        );
		
u_ddr3_model1:  ddr3_model 
port map (
    
        rst_n      => ddr3_reset_n,
        ck         => ddr3_ck_p(0),
        ck_n       => ddr3_ck_n(0),
        cke        => ddr3_cke(0),
        cs_n       => ddr3_cs_n(0),
        ras_n      => ddr3_ras_n,
        cas_n      => ddr3_cas_n,
        we_n       => ddr3_we_n,
        dm_tdqs    => ddr3_dm_conv(3 downto 2),
        ba         => ddr3_ba,
        addr       => ddr3_addr,
        dq         => ddr3_dq(31 downto 16),
        dqs        => ddr3_dqs_p(3 downto 2),
        dqs_n      => ddr3_dqs_n(3 downto 2),
        tdqs_n     => open,
        odt        => ddr3_odt(0)
		
        );
		
		
u_Top:  Top 
port map (
    

	    rst		                   =>    rst		             ,
	    soft_rst		           =>    '1'		             ,
	    rst_led		               =>    rst_led		         ,
	    locked_led                 =>    locked_led              ,
	    clk_in1_p                  =>    clk_in1_p               ,
	    clk_in1_n                  =>    clk_in1_n               ,
	    ddr3_addr	               =>    ddr3_addr	             ,
	    ddr3_ba		               =>    ddr3_ba		         ,
	    ddr3_ck_p	               =>    ddr3_ck_p	             ,
	    ddr3_ck_n	               =>    ddr3_ck_n	             ,
	    ddr3_cke	               =>    ddr3_cke	             ,
	    ddr3_cs_n	               =>    ddr3_cs_n	             ,
	    ddr3_ras_n	               =>    ddr3_ras_n	             ,
	    ddr3_cas_n	               =>    ddr3_cas_n	             ,
	    ddr3_we_n                  =>    ddr3_we_n               ,
	    ddr3_dq		               =>    ddr3_dq		         ,
	    ddr3_dqs_p	               =>    ddr3_dqs_p	             ,
	    ddr3_dqs_n	               =>    ddr3_dqs_n	             ,
	    ddr3_dm		               =>    ddr3_dm		         ,
	    ddr3_odt	               =>    ddr3_odt	             ,
	    ddr3_reset_n               =>    ddr3_reset_n            ,
	    init_calib_complete        =>    init_calib_complete     ,
		
    	eth_rxck                   =>    eth_rxck                ,
        eth_txck                   =>    eth_txck                ,
        eth_txd                    =>    eth_txd                 ,
        eth_tx_en                  =>    eth_tx_en               ,
        eth_rxd                    =>    eth_rxd                 ,
        eth_rxctl                  =>    eth_rxctl               ,
        eth_mdio                   =>    eth_mdio                ,
        eth_mdc                    =>    eth_mdc                 ,
        eth_phyrst_n               =>    eth_phyrst_n            ,
        eth_int_b                  =>    eth_int_b               ,
		
    	sin0	                   =>    uart_out	                 ,
    	sout0	                   =>    uart_out	                 , 

	    proc_beat                  =>    proc_beat 
               		
  
    ); 
	
end Behavioral;
