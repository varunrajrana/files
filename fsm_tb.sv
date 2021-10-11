`timescale 1ns / 1ps

module fsm_tb();

    logic clk,reset,DeviceReq,ServerResp,DNSResp;
    logic DNSReq,ServerReq,DeviceResp;

    router dut(.*);

    initial begin
        clk=0; #5;
	reset=0;
        forever begin
            clk=1; #5;
            clk=0; #5;
        end
    end

    initial begin
	#5;
	reset=1;
	#10;
	reset=0;
	#5;

	//Test descriptions present in $display statements.

	assert(dut.DeviceResp==0 && dut.ServerReq==0 && dut.DNSReq==0) $display("Initial setup correct");
	else $error("failed initial setup");

	$display("Check correct operation of Full cycle. Device Requesting...");
	DeviceReq=1;

	#20;

	assert(dut.state==dut.get_device_request) $display("Test1 Pass- Getting Device Request");
	else $error("Failed Test1");

	#10;
	
	assert(dut.state==dut.dns_query && dut.DNSReq==1) $display("Test2 Pass- Resolving DNS query");
	else $error("Failed Test2");

	DNSResp=1;
	#10

	assert(dut.state==dut.verify_dns) $display("Test3 Pass- Verifying DNS query response");
	else $error("Failed Test3");
	
	#10;

	assert(dut.state==dut.send_server_request && dut.ServerReq==1) $display("Test4 Pass- Sending Server Request");
	else $error("Failed Test4");

	#10;
	
	assert(dut.state==dut.await) $display("Test5 Pass- Awaiting Response");
	else $error("Failed Test5");

	$display("Server now Responding...");
	ServerResp=1;

	#20;
	assert(dut.state==dut.get_server_response) $display("Test6 Pass- Recieving server response");
	else $error("Failed Test6");

	#10;

	assert(dut.state==dut.verify_pkt) $display("Test7 Pass- Verifying packet");
	else $error("Failed Test7");

	#10;

	assert(dut.state==dut.deliver_response && dut.DeviceResp==1) $display("Test8 Pass- Delivering packet");
	else $error("Failed Test8");
	DeviceReq=0;
	DNSResp=0;
	ServerResp=0;
	#10;
	assert(dut.state==dut.idle) $display("Test9 Pass- Returned to idle");
	else $error("Failed Test9");
        #5;
	
	$display("Test cancel and fail verify cases");
	
	DeviceReq=1;
	#30;
	DNSResp=1;
	DeviceReq=0;
	ServerResp=1;
	
	#55;
	assert(dut.state==dut.cancel_request) $display("Test10 Pass- Request was cancelled, no payload sent to device");
	else $error("Failed Test10");
	#10;
	$display("Test cancel and fail verify cases");
	DNSResp=1;
	DeviceReq=1;
	ServerResp=1;
	#70;
	ServerResp=0;
	#20;
	assert(dut.state==dut.fail_verify) $display("Test11 Pass- Packet verification failed, no payload sent to device");
	else $error("Failed Test11");

	#50
        $stop;
    end

endmodule: fsm_tb