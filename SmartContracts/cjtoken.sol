pragma solidity ^0.4.16;

// https://github.com/ethereum/EIPs/issues/20

contract ERC20 {
    function totalSupply() constant returns (uint totalSupply);
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    
    // These generate a public event on the blockchain that will notify clients
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

}

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract CJTToken is ERC20, owned {
    // Public variables of the token
    string public name = "Coin Joker Token";
    string public symbol = "CJT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 105 * 10**6 * 10**18;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;

    // This creates an array with all allowances
    mapping (address => mapping (address => uint256)) public allowance;


    /**
     * Constructor function
     *
     * Gives ownership of all initial tokens to the Coin Joker Team. Sets ownership of contract
     */
    function CJTToken(
        address cjTeam;
    ) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        if (cjTeam != 0) owner = cjTeam;
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(
        address _from, 
        address _to, 
        uint _value
    ) internal {
        require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[_from] >= _value);                // Check if the sender has enough
        require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        Transfer(_from, _to, _value);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(
        address _to, 
        uint256 _value
    ) {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(
        address _from, 
        address _to, 
        uint256 _value
    ) returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(
        address _spender, 
        uint256 _value
    ) returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * Get current balance of account _owner
     *
     * @param _owner The owner of the account
     */
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    /**
     * Get allowance from _owner to _spender
     *
     * @param _owner The address that authorizes to spend
     * @param _spender The address authorized to spend
     */
    function allowance(
        address _owner, 
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
     * Get total supply of all tokens
     */
    function totalSupply() constant returns (uint totalSupply) {
        return totalSupply;
    }
}
