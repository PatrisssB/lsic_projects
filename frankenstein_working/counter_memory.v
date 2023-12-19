module counter_memory
(
    input clk, rst,
    input start, pause, stop, 
    output wire tick,
    output wire [3:0] unit_tick,
    
    // memory ports
    input [7:0] mem_data_read,
    input mem_read, // enable read
    input [7:0] mem_data_write,
    input mem_write, // enable write
    input [7:0] mem_address
);

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;
localparam STOP = 2'b11;

reg [31:0] counter_reg, counter_nxt;
reg [7:0] unit_tick_reg, unit_tick_nxt;
reg tick_reg, tick_nxt;
reg [3:0] state_reg, state_nxt;
reg [7:0] pause_address; // Memory address for pause values
reg [7:0] instruction_address; // Memory address for instructions

// Memory instantiation
memory #(8, 8) mem_inst 
(
    .clk(clk),
    .rst(rst),
    .rd_wr_en(mem_write),
    .data_in(counter_reg),
    .addr(pause_address),
    .data_out()
);

always @(posedge clk or negedge rst) 
begin
    if (~rst) 
    begin
        counter_reg <= 32'b0;
        tick_reg <= 1'b0;
        unit_tick_reg <= 8'b0;
        state_reg <= IDLE;
        pause_address <= 8'b0;
    end 
    else 
    begin
        counter_reg <= counter_nxt;
        tick_reg <= tick_nxt;
        unit_tick_reg <= unit_tick_nxt;
        state_reg <= state_nxt;
        pause_address <= pause_address;
    end
end

assign tick = tick_reg;
assign unit_tick = unit_tick_reg;

always @(*) 
begin
    counter_nxt = counter_reg;
    tick_nxt = tick_reg;
    unit_tick_nxt = unit_tick_reg;
    state_nxt = state_reg;
    
    // Memory read operation
    if (mem_read)
    begin
        case (mem_address)
            8'b0000_0000: // Read from pause address
                assign mem_data_read = mem_inst.data_out;
                mem_address = mem_address + 1;
            default: 
                state_nxt = state_reg;
        endcase
    end

    if (stop)
    begin
        case (mem_address)
            8'b0000_0000: // Read from pause address
                mem_data_read = mem_inst.data_out;
                mem_address = mem_address + 1;
            default:
                // Handle other memory addresses if needed
                state_nxt = state_reg;
        endcase
    end

    case (state_reg)
        IDLE: 
        begin
            unit_tick_nxt = 8'b0;
            tick_nxt = 1'b0;
            if (state_reg == START) 
            begin
                state_nxt = START;
            end
        end
      
        START: 
        begin
            if (counter_reg == 50_000_000 - 1) 
            begin
                counter_nxt = 32'b0;
                tick_nxt = 1'b1;
                unit_tick_nxt = unit_tick_reg + 8'b1;
            end 
            else 
            begin
                counter_nxt = counter_reg + 1'b1;
                tick_nxt = 1'b0;
            end
            
            if (mem_write && (mem_address == 8'b0000_0000)) // pause address
            begin
                mem_inst.mem_data_write <= counter_reg;
            end

            if (start & pause)  //ERROR
            begin
                state_nxt = PAUSE;
            end
            
            if (!start && !pause)  //ERROR
            begin
                state_nxt = IDLE;
            end
        end
      
        PAUSE: 
        begin
            counter_nxt = counter_reg;
            unit_tick_nxt = unit_tick_reg; //
            if (start && !pause) //error
            begin
                state_nxt = START;
            end
        end

        STOP:
        begin
            
        end
    endcase
end

endmodule
