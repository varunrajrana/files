module router (
	input logic clk,
	input logic reset,
	input logic DeviceReq,
	input logic ServerResp,
	input logic DNSResp,
	output logic DeviceResp,
	output logic ServerReq,
	output logic DNSReq
);

//States for router
enum {
	idle,
	get_device_request ,
	dns_query ,
	verify_dns,
	send_server_request ,
	await ,
	get_server_response,
	verify_pkt,
	deliver_response,
	fail_verify,
	cancel_request
	} state,nstate;

always_ff @( posedge clk ) state=nstate;

//state progression. default state idle where waiting for requests
always_ff @( posedge clk ) begin
	if (reset) state <= idle;
	else 
		case (state)
		idle : begin
			if (DeviceReq==1)	nstate = get_device_request;	//if a request is made, go to recieve state
			else begin	//stay idle
				DeviceResp=0;
				DNSReq=0;
				ServerReq=0;
				nstate=idle;
			end
		end
		//acknowledge request and transmission
		get_device_request : begin	
			nstate = dns_query;
		end

		//request resolution from dns server
		dns_query : begin
			DNSReq = 1;
			nstate = verify_dns;
		end

		//wait for and check dns resolution
		verify_dns : begin
			if (DNSResp==1) begin		//recieve response, prep to send req to resolved servername
				nstate = send_server_request;
				DNSReq=0;
			end	
			else nstate = verify_dns;	//wait for dnsresponse
		end

		//send request to server
		send_server_request : begin
			ServerReq=1;
			nstate = await;
		end

		//wait for a response from the server
		await : begin
			if (ServerResp==1) nstate = get_server_response;
			else nstate = await;
		end

		//state where response is recieved.
		get_server_response : begin
			nstate = verify_pkt;
			//ServerReq=0;
		end

		//state simulating verification of packet integrity
		verify_pkt : begin
			if(~DeviceReq) nstate = cancel_request;		//if device cancels, dont send payload to device
			else begin
				if(ServerReq==ServerResp) nstate=deliver_response;	
				else nstate = fail_verify;	//if failed to verify 
			end
		end

		//deliver response to our device
		deliver_response : begin
			if(~DeviceReq) nstate = cancel_request;	//if the request was canccelled do not deliver.
			else begin
				DeviceResp=1;
				nstate = idle;
			end
		end

		//payload verification fail state
		fail_verify : begin
			nstate = idle;
		end
		
		//cancelled  request state
		cancel_request : begin
			nstate=idle;
		end
		default: nstate <= idle;
	endcase
end
endmodule