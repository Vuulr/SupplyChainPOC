/*
 * Avails Trade POC Contract
 * Copyright 2017 Vuulr Pte Ltd
 * https://www.vuulr.com
 *
 * Chris Drumgoole, CTO - chris.drumgoole@vuulr.com
 */

pragma solidity ^0.4.18;

contract VuulrAvailsTrade {

    address owner; // Owner of contract

    string public standard = 'VuulrAvailsTrade';
    string public name;
    string public symbol;
    uint8 public decimals;

    // State Variables
    uint256 public totalRights;

    // Array storing balance of avails tokens for each ethereum wallet address
    mapping (address => uint256) public balanceOf;

    // Array storing array of Avails Hashes associated with an address
    mapping (address => bytes32[]) public rightsHeld;

    // Array storing ownership of an Avails object to an ethereum wallet address
    mapping (address => Avail[]) public availsOwnershipHashToAddress;

    // Struct storing information about the Avails
    struct Avail {
      bytes32 availHash;  // Unique identifer of avail - different from content UID
      bytes32 contentUID;   // Link to content identifier
      string geographies; // TEMPORARY raw string storing geographies of the avails - need to build out
      string rightsType;    // TEMPORARY raw string storing geographies of the avails - need to build out


      // TODO exclusivity bool
      // hold back (partial buy) - allow for different rights,
      // so i am buying FTA, but i want a hold back on VOD and PAYTV for a different period


      uint256 availRightsStartDate;
      uint256 availRightsEndDate;

      // Todo: think about if wallet addresses of entity(ies) change, how to handle?
      address issuer;     // Address of entity who issued the Avail - the 'seller'
      address recipient;  // Address of entity who received the Avail - the 'buyer'
    }


    /* Initializes contract with initial supply tokens to the creator of the contract */
    function VuulrAvailsTrade() public payable {
        owner = msg.sender;     // Contract is owned by the creator
        totalRights = 0;        // Start off with zero avail tokens - we'll manage this as we go
        name = "VUULR_AVAILS";  // Set the name for display purposes
        symbol = "VAVAILS";     // Set the symbol for display purposes
        decimals = 0;           // Since this is not a monitary token, we don't want decimals
    }

    // Create initial credential contract
    function createAndAssignAvail(bytes32 _contentUID, address _issuer, address _recipient, uint256 _availRightsStartDate, uint256 _availRightsEndDate, string _geos, string _rightsType) public
    {
      /*
       * Tests
       */

      // 1234, "0x4fA61b525CBAFdb29619697B68b46436256E5408", "0x4fA61b525CBAFdb29619697B68b46436256E5408", 1514764800, 1546300799,"SG, MY", "VOD"
      // 5678, "0xB804DB3928B17f3C32b6de2ECe613aAa05193F00", "0x4fA61b525CBAFdb29619697B68b46436256E5408", 1514764800, 1546300799,"AU, US", "FTA"

      // Need too add contractual terms etc

      bytes32 newAvailHash = keccak256(_contentUID, _availRightsStartDate, _availRightsEndDate, _geos, _rightsType);
      availsOwnershipHashToAddress[_recipient].push(Avail(newAvailHash, _contentUID, _geos, _rightsType, _availRightsStartDate, _availRightsEndDate, _issuer, _recipient));

      totalRights += 1; // Increment total supply of avail tokens - for count purposes

      balanceOf[_recipient]++;
      rightsHeld[_recipient].push(newAvailHash);
    }

}
