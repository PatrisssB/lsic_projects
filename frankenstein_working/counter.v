module counter#(parameter CLOCK_CYCLES = 50_000_000, MEM_SIZE = 1024, MEM_WIDTH = 8) 
(
    input clk, rst,
    output wire tick,
    output wire [3:0] unit_tick,
    
    // memory ports
    input [MEM_WIDTH-1:0] mem_data_read,
    input mem_read, //enable read
    input [MEM_WIDTH-1:0] mem_data_write,
    input mem_write, //enable write
    input [MEM_WIDTH-1:0] mem_address
);


//task: when you press PAUSE the value that is remained, please store it in the memory 
//the previous acction will need to have the address increasead 
//in the case: zm m zs s -> it should be concatenated and the whole value it should be stored into the meomory
//when STOP is pressed, then you should read ALL the values stored in the memory
//there can be dislayed like: from top-bottom or bottom/-top, all the values are shown one after another
//the other method can associate a button to make it go throgh them pressing each time
//optional stuff(not so optional for me:))))) 
//it requires the usage of another memory that will store the operations that we did, basicalyy the upcode 
//also it can store the operation done/upcode and the value 
//use the 2nd memory as the control unit of the stopwatch that should have a list of the instructions that would control the stopwatch itself


reg [31:0] counter_reg, counter_nxt;
reg [7:0] unit_tick_reg, unit_tick_nxt;
reg tick_reg, tick_nxt;
reg [3:0] state_reg, state_nxt;

//for the adding the given memory module, there is an instantiation needed of the module
//then it should be modified 

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;

assign tick = tick_reg;
assign unit_tick = unit_tick_reg;

always @(*) 
begin
    counter_nxt = counter_reg;
    tick_nxt = tick_reg;
    unit_tick_nxt = unit_tick_reg;
    state_nxt = state_reg;
    
    // memo read op
    if (mem_read)
    begin
        case (mem_address)
            // ...
            default: 
                state_nxt = state_reg;
        endcase
    end
    
    case (state_reg)
        IDLE: 
        begin
            unit_tick_nxt = 8'b0;
            tick_nxt = 0;
            if (state_reg == START) 
            begin
                state_nxt = START;
            end
        end
      
        START: begin
            if (counter_reg == CLOCK_CYCLES - 1) 
            begin
                counter_nxt = 'b0;
                tick_nxt = 1'b1;
                unit_tick_nxt = unit_tick_reg + 8'b1;
            end 
            else 
            begin
                counter_nxt = counter_reg + 1'b1;
                tick_nxt = 1'b0;
            end
            
            if (start & pause) 
            begin
                state_nxt = PAUSE;
                
                // mem write op when PAUSE opcode is seen
                if (mem_write && (mem_address == 2'b10 )) //pause opcode address
                begin
                    memory[mem_address] <= counter_reg;
                end
            end
            
            if (!start && !pause) 
            begin
                state_nxt = IDLE;
            end
        end
      
        PAUSE: 
        begin
            counter_nxt = counter_reg;
            unit_tick_nxt = unit_tick_reg;
            if (start && !pause) 
            begin
                state_nxt = START;
            end
        end
    endcase
end

always @(posedge clk or negedge rst) 
begin
    if (~rst) 
    begin
        counter_reg <= 'b0;
        tick_reg <= 1'b0;
        unit_tick_reg <= 8'b0;
        state_reg <= IDLE;
    end 
    else 
    begin
        counter_reg <= counter_nxt;
        tick_reg <= tick_nxt;
        unit_tick_reg <= unit_tick_nxt;
        state_reg <= state_nxt;
    end
end
endmodule
