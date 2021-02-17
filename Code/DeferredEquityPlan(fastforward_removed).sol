pragma solidity ^0.5.0;

contract DeferredEquityPlan {
    address human_resources;
    address payable employee;
    bool active = true; // this employee is active at the start of the contract
    uint total_shares = 1000;
    uint annual_distribution = 250;

    uint start_time = now;
    uint unlock_time = start_time + 365 days;

    uint public distributed_shares;

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time <= now, "Your shares aren't vested.");
        require(distributed_shares <= total_shares, "All shares have been distributed.");

        unlock_time += 365 days;
        distributed_shares = ((now - start_time) / 365 days * annual_distribution);
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}