module DualPortRam_tb;
    localparam XLEN = 32;
    localparam ADDR_WIDTH = 5;
    reg                         i_clk, i_we;
    reg     [(XLEN-1):0]        i_dataIn;
    reg     [(ADDR_WIDTH-1):0]  i_rAddr, i_wAddr;
    wire    [(XLEN-1):0]        o_q;

    DualPortRam DualPortRam_dut(.*);
    defparam DualPortRam_dut.XLEN = XLEN;
    defparam DualPortRam_dut.ADDR_WIDTH = ADDR_WIDTH;

    reg [31:0] testData [0:9];
    initial begin
        testData[0] = 32'hdeadbeef;
        testData[1] = 32'h8badf00d;
        testData[2] = 32'h00c0ffee;
        testData[3] = 32'hdeadc0de;
        testData[4] = 32'hbadf000d;
        testData[5] = 32'hdefac8ed;
        testData[6] = 32'hcafebabe;
        testData[7] = 32'hdeadd00d;
        testData[8] = 32'hcafed00d;
        testData[9] = 32'hdeadbabe;
    end

    // Test loop
    reg [39:0] resultStr;
    integer i = 0, errs = 0, subfail = 0;
    initial begin
        i_clk     = 0;
        i_we      = 1;
        i_dataIn  = 'd0;
        i_rAddr   = 'd0;
        i_wAddr   = 'd0;
        #20;

        for (i=0; i<10; i=i+1) begin // Write
            #20; i_clk = ~i_clk;
            i_wAddr  = i[4:0];
            i_dataIn = testData[i];
            #20; i_clk = ~i_clk;
        end

        i_we      = 0;
        for (i=0; i<10; i=i+1) begin // Read
            #20; i_clk = ~i_clk;
            i_rAddr = i[4:0];
            #20; i_clk = ~i_clk;
            if (o_q != testData[i]) resultStr = "ERROR";
            else                    resultStr = "PASS ";
            if (resultStr == "ERROR") errs = errs + 1;
        end

        if (errs > 0)   $display("DualPortRam tests - FAILED: %0d", errs);
        else            $display("DualPortRam tests - PASSED");
    end

endmodule