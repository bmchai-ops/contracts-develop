pragma solidity ^0.8.0;

contract GovernanceTokenFactory {

    address public tokengenerator;
    //address of tokegenerator - controlled by us
     modifier onlytokengenerator {
      require(msg.sender == tokengenerator, "permission: only Factory");
      _;
    }
}
    function settokengenerator(address _tokengenerator) external onlyOwner returns (address) {
        tokengenerator = _tokengenerator;
        return tokengenerator;
    }
    event TokenCreated(address tokenAddress, address creator);
    
    function createToken(string memory name, string memory symbol, uint256 totalSupply, address[] memory stakeholders) onlytokengenerator public returns(address) {
        require(stakeholders.length == percentages.length, "Stakeholders and percentages arrays must have the same length");
        
        // Create a new governance token contract
        GovernanceToken newToken = new GovernanceToken(name, symbol, totalSupply, msg.sender);
        
        emit TokenCreated(address(newToken), msg.sender);
        return address(newToken);
    }
}

contract GovernanceToken is ERC20 {
    
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) public allowed;
    mapping(uint256 => Proposal) public proposals;
    
    struct Percentage {
    address addr;
    uint256 value;
}

    Percentage[] private percentages;
    
    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startTime;
        uint256 endTime;
        mapping(address => bool) voters;
    }
    
    uint256 public proposalCount;
    uint256 public voteTimeLimit;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event GovernanceVote(address indexed voter, uint256 indexed proposalId, uint256 votesFor, uint256 votesAgainst);
    event NewGovernanceProposal(uint256 indexed proposalId, string description);
    
    constructor(string memory _name, string memory _symbol, uint256 _totalSupply, address _owner) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        owner = _owner;
        balances[_owner] = _totalSupply;
        proposalCount = 0;
        
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
    
    function addPercentage(address _addr, uint256 _value) public {
    	percentages.push(Percentage(_addr, _value));
}
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[msg.sender], "Insufficient balance");
        emit Transfer(msg.sender, _to, _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[_from], "Insufficient balance");
        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
        emit Transfer(_from, _to, _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        return true;
    }
     function createProposal(string memory _description, uint256 _endTime) public {
        proposalCount++;
        proposals[proposalCount] = Proposal(
            proposalCount,
            _description,
            0,
            0,
            block.timestamp,
            _endTime,
            mapping(address => bool)()
        );
    }
    function vote(uint256 _proposalId, uint256 _voteWeight) public returns (bool) {
    	require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal ID");
   	Proposal storage proposal = proposals[_proposalId];
    	require(block.timestamp >= proposal.startTime && block.timestamp <= proposal.endTime, "Voting period has ended");
    	require(balances[msg.sender] > 0, "You do not have any tokens to vote with");
    	require(!proposal.voters[msg.sender], "You have already voted on this proposal");
    	require(_voteWeight <= balances[msg.sender], "Vote weight cannot exceed token balance");
    
    	proposal.voters[msg.sender] = true;
    	if (_voteWeight == 0) {
        // No vote
    	} else if (_voteWeight > 0) {
        // Vote for
        proposal.votesFor += _voteWeight;
    	} else {
        // Vote against
        proposal.votesAgainst += -1 * _voteWeight;
    	}
    	emit GovernanceVote(msg.sender, _proposalId, proposal.votesFor, proposal.votesAgainst);
    	return true;
}

   
